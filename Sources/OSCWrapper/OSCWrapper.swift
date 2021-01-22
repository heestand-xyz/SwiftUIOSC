import OSCKit

public class OSCWrapper {
    
    public static let shared: OSCWrapper = .init()
    
    let client: OSCClient
    let server: OSCServer
    
    /// Remote IP Address
    public var clientAddress: String = "localhost" {
        didSet { client.host = clientAddress }
    }
    /// Remote Port
    public var clientPort: Int = 8000 {
        didSet { client.port = UInt16(clientPort) }
    }
    /// Local Port
    public var serverPort: Int = 7000 {
        didSet { server.port = UInt16(serverPort) }
    }
    
    let taker: OSCTaker
    
    init() {
        
        client = OSCClient()
        client.host = clientAddress
        client.port = UInt16(clientPort)
        
        taker = OSCTaker(take: { address, values in
            print("OSCWrapper - Received OSC at \(address)", values)
        })
        
        server = OSCServer()
        server.port = UInt16(serverPort)
        server.delegate = taker
        do {
            try server.startListening()
        } catch {
            print("OSCWrapper - OSC Server - Failed to Listen:", error)
        }
        
    }
    
    func send(value: Any, at address: String) {
        send(values: [value], at: address)
    }
    
    func send(values: [Any], at address: String) {
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
