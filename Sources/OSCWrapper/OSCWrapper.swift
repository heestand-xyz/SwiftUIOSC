import Foundation
import OSCKit

public class OSCWrapper: ObservableObject {
    
    public static let shared: OSCWrapper = .init()
    
    let client: OSCClient
    let server: OSCServer
    
    /// Remote IP Address
    @Published public var clientAddress: String = "localhost" {
        didSet {
            client.host = clientAddress
        }
    }
    /// Remote Port
    @Published public var clientPort: Int = 8000 {
        didSet {
            client.port = UInt16(clientPort)
        }
    }
    /// Local Port
    @Published public var serverPort: Int = 7000 {
        didSet {
            server.port = UInt16(serverPort)
            listen()
        }
    }
    
    let taker: OSCTaker
    
    init() {
        
        client = OSCClient()
        server = OSCServer()

        taker = OSCTaker(take: { address, values in
            print("OSCWrapper - Received OSC at \(address)", values)
        })
        
        client.host = clientAddress
        client.port = UInt16(clientPort)

        server.port = UInt16(serverPort)
        server.delegate = taker

        listen()
        
    }
    
    func listen() {
        do {
            try server.startListening()
            print("OSCWrapper - Server listening on port \(serverPort)")
        } catch {
            print("OSCWrapper - Server failed to listen on port \(serverPort):", error)
        }
    }
    
    func send(value: Any, at address: String) {
        send(values: [value], at: address)
    }
    
    func send(values: [Any], at address: String) {
        var address: String = address
        if address.first != "/" {
            address = "/\(address)"
        }
        print("OSCWrapper - Sent OSC at \(address)", values)
        let message = OSCMessage(with: address, arguments: values)
        client.send(packet: message)
    }
    
}

class OSCTaker: OSCPacketDestination {
    
    let take: (String, [Any]) -> ()
    
    init(take: @escaping (String, [Any]) -> ()) {
        self.take = take
    }
    
    public func take(message: OSCMessage) {
        let address: String = message.addressPattern
        let values: [Any] = message.arguments
        take(address, values)
    }
    
    public func take(bundle: OSCBundle) {}
    
}
