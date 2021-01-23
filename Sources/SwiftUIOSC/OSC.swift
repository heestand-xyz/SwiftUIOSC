import Foundation
import OSCKit
import Reachability

public class OSC: ObservableObject, OSCConnectionMonitorDelegate {
    
    public static let shared: OSC = .init()
    
    let client: OSCClient
    let server: OSCServer
    
    // Local IP Address
    @Published var _serverAddress: String?
    public var serverAddress: String? { _serverAddress }
    /// Local Port
    @Published public var serverPort: Int = 7000 {
        didSet {
            server.port = UInt16(serverPort)
            listen()
        }
    }
    
    /// Remote IP Address
    @Published public var clientAddress: String = "localhost" {
        didSet {
            client.host = clientAddress
            print("SwiftUIOSC - Client sending to address \(clientAddress).")
        }
    }
    /// Remote Port
    @Published public var clientPort: Int = 8000 {
        didSet {
            client.port = UInt16(clientPort)
            print("SwiftUIOSC - Client sending on port \(clientPort).")
        }
    }
    
    let taker: OSCTaker
    
    let connectionMonitor: OSCConnectionMonitor
    @Published public var connection: OSCConnection = .unknown
    
    init() {
        
        client = OSCClient()
        server = OSCServer()

        taker = OSCTaker(take: { address, values in
            print("SwiftUIOSC - Received OSC at \"\(address)\" with values:", values)
        })
        
        connectionMonitor = OSCConnectionMonitor()
        connectionMonitor.delegate = self
        
        client.host = clientAddress
        client.port = UInt16(clientPort)

        server.port = UInt16(serverPort)
        server.delegate = taker

        listen()
        
    }
    
    func listen() {
        do {
            try server.startListening()
            print("SwiftUIOSC - Server listening on port \(serverPort).")
        } catch {
            print("SwiftUIOSC - Server failed to listen on port \(serverPort):", error)
        }
    }
    
    func send(_ oscArrayValues: OSCArrayValue, at address: String) {
        let values: [Any] = oscArrayValues.values
        var address: String = address
        if address.first != "/" {
            address = "/\(address)"
        }
        print("SwiftUIOSC - Sent OSC at \"\(address)\" with values:", values)
        let message = OSCMessage(with: address, arguments: values)
        client.send(packet: message)
    }
    
    func connectionMonitor(connection: OSCConnection) {
        self.connection = connection
    }
    
    func connectionMonitor(ipAddress: String?) {
        _serverAddress = ipAddress
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
