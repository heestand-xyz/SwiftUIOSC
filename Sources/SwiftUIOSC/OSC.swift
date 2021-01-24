import Foundation
import OSCKit
import Reachability

public class OSC: ObservableObject, OSCConnectionMonitorDelegate {
    
    public static let shared: OSC = .init()
    
    let client: OSCClient
//    let server: OSCServer

//    // Local IP Address
//    @Published var _serverAddress: String?
//    public var serverAddress: String? { _serverAddress }
//    /// Local Port
//    @Published public var serverPort: Int = 7000 {
//        didSet {
//            server.port = UInt16(serverPort)
//            listen()
//        }
//    }
//    @Published public var serverPortOpen: Bool = false
    
    /// Remote IP Address
    @Published public var clientAddress: String = "localhost" {
        didSet {
            client.host = clientAddress
            print("SwiftUIOSC - Sending to client on address: \(clientAddress)")
        }
    }
    /// Remote Port
    @Published public var clientPort: Int = 8000 {
        didSet {
            client.port = UInt16(clientPort)
            print("SwiftUIOSC - Sending to client on port: \(clientPort)")
        }
    }
    
    let taker: OSCTaker
    
    let connectionMonitor: OSCConnectionMonitor
    @Published public var connection: OSCConnection = .unknown
    
//    var receivers: [String: ([Any]) -> ()] = [:]
    
    // MARK: - Life Cycle
    
    init() {
        
        client = OSCClient()
//        server = OSCServer()

        taker = OSCTaker()
        
        connectionMonitor = OSCConnectionMonitor()
        connectionMonitor.delegate = self
        
        client.host = clientAddress
        client.port = UInt16(clientPort)
        client.delegate = taker

//        server.port = UInt16(serverPort)
//        server.delegate = taker

//        listen()
        
//        taker.take = { address, values in
//            for receiver in self.receivers {
//                if receiver.key == address || "/" + receiver.key == address {
//                    receiver.value(values)
//                }
//            }
//        }
        
    }
    
    // MARK: - Register
    
//    func register<T: OSCArrayValue>(oscState: OSCState<T>) {
//        receivers[oscState.address] = { values in
//            let value: T = .convert(values: values)
//            print("--->", value)
//            oscState.receiving = true
//            oscState.value = value
//            oscState.receiving = false
//            print("<---", value)
//        }
//    }
    
    // MARK: - Receive
    
//    func receive<T: OSCArrayValue>(on address: String, to value: Binding<T>) {
//        receivers[address] = { values in
//            let tValue: T = .convert(values: values)
//            print(">>>>>>>", tValue)
//            value.wrappedValue = tValue
//        }
//    }
    
//    func receive<T: OSCArrayValue>(on address: String, state: State<T>) {
//        receivers[address] = { values in
//            let value: T = .convert(values: values)
//            print(">>>>>>>", value)
//            state.wrappedValue = value
//        }
//    }

//    func receive(on address: String, _ callback: @escaping ([Any]) -> ()) {
//        receivers[address] = { values in
//            callback(values)
//        }
//    }
    
//    func receive(on address: String) {
//        receivers[address] = { values in
//            NotificationCenter.default.post(name: .osc, object: nil, userInfo: ["oscValues" : values])
//        }
//    }
    
    // MARK: - Listen
    
//    func listen() {
//        serverPortOpen = connectionMonitor.isPortOpen(port: in_port_t(serverPort))
//        if !serverPortOpen {
//            print("SwiftUIOSC - Server port not open: \(serverPort)")
//        }
//        do {
//            try server.startListening()
//            print("SwiftUIOSC - Server listening on port: \(serverPort)")
//        } catch {
//            print("SwiftUIOSC - Server failed to listen on port: \(serverPort) - error:", error)
//        }
//    }
    
    // MARK: - Send
    
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
    
    // MARK: - Connection Monitor
    
    func connectionMonitor(connection: OSCConnection) {
        self.connection = connection
    }
    
    func connectionMonitor(ipAddress: String?) {
//        _serverAddress = ipAddress
    }
    
}

class OSCTaker: OSCClientDelegate & OSCPacketDestination {
    
    var take: ((String, [Any]) -> ())?
    
    func clientDidConnect(client: OSCClient) {
        print("SwiftUIOSC - Client did connect.")
    }
    
    func clientDidDisconnect(client: OSCClient) {
        print("SwiftUIOSC - Client did disconnect.")
    }
    
    public func take(message: OSCMessage) {
        let address: String = message.addressPattern
        let values: [Any] = message.arguments
        print("SwiftUIOSC - Received OSC at \"\(address)\" with values:", values)
        take?(address, values)
    }
    
    public func take(bundle: OSCBundle) {
        for element in bundle.elements {
            guard let message = element as? OSCMessage else { continue }
            take(message: message)
        }
    }
    
}
