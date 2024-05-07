import Foundation
import Observation
import OSCKit
import Reachability

@Observable
public class OSC: OSCConnectionMonitorDelegate {
    
    public static let shared: OSC = .init()
    
    private var client: OSCUdpClient?
    private var server: OSCUdpServer?

    private static let defaultServerPort: Int = 7_000
    /// Local Port
    public var serverPort: Int = OSC.defaultServerPort {
        didSet {
            server?.port = UInt16(serverPort)
            listen()
        }
    }
    public var serverPortOpen: Bool = false
    
    private static let defaultClientAddress: String = "localhost"
    /// Remote IP Address
    public var clientAddress: String = OSC.defaultClientAddress {
        didSet {
            client?.host = clientAddress
            print("SwiftUIOSC - Sending to client on address: \(clientAddress)")
        }
    }
    
    private static let defaultClientPort: Int = 8_000
    /// Remote Port
    public var clientPort: Int = OSC.defaultClientPort {
        didSet {
            client?.port = UInt16(clientPort)
            print("SwiftUIOSC - Sending to client on port: \(clientPort)")
        }
    }
    
    private let connectionMonitor: OSCConnectionMonitor
    public var connection: OSCConnection = .unknown
    
    private var receivers: [String: ([OSCArgumentProtocol]) -> ()] = [:]
    
    // MARK: - Life Cycle
    
    init() {

        connectionMonitor = OSCConnectionMonitor()
        connectionMonitor.delegate = self

        client = OSCUdpClient(
            host: OSC.defaultClientAddress,
            port: UInt16(OSC.defaultClientPort),
            delegate: self,
            queue: .main
        )
        
        server = OSCUdpServer(
            port: UInt16(OSC.defaultServerPort),
            delegate: self,
            queue: .main
        )
        
        listen()
    }
    
    // MARK: - Register
    
    func register<T: OSCArrayValue>(oscState: OSCState<T>) {
        receivers[oscState.address] = { values in
            let value: T = .convert(values: values)
            oscState.receiving = true
            oscState.value = value
            oscState.receiving = false
        }
    }
    
    // MARK: - Listen
    
    private func listen() {
        server?.stopListening()
        serverPortOpen = connectionMonitor.isPortOpen(port: in_port_t(serverPort))
        if !serverPortOpen {
            print("SwiftUIOSC - Server port not open: \(serverPort)")
        }
        do {
            try server?.startListening()
            print("SwiftUIOSC - Server listening on port: \(serverPort)")
        } catch {
            print("SwiftUIOSC - Server failed to listen on port: \(serverPort) - error:", error)
        }
    }
    
    // MARK: - Send
    
    func send(_ oscArrayValues: OSCArrayValue, at address: String) {
        let values: [OSCArgumentProtocol] = oscArrayValues.values
        var address: String = address
        if address.first != "/" {
            address = "/\(address)"
        }
        do {
            let message = try OSCMessage(with: address, arguments: values)
            try client?.send(message)
            print("SwiftUIOSC - Sent OSC at \"\(address)\" with values:", values)
        } catch {
            print("SwiftUIOSC - Failed to send OSC at \"\(address)\" with values:", values, "Error:", error)
        }
    }
    
    // MARK: - Receive
    
    private func receive(message: OSCMessage) {
                
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            
            guard let self = self else { return }
            
            let address: String = message.addressPattern.fullPath
            guard address != "/_samplerate" else { return }
            let values: [OSCArgumentProtocol] = message.arguments
            
            print("SwiftUIOSC - Received OSC at \"\(address)\" with values:", values)

            receivers[address]?(values)
        }
    }

    private func receive(bundle: OSCBundle) {
                
        for element in bundle.elements {
            guard let message = element as? OSCMessage else { continue }
            receive(message: message)
        }
    }
    
    // MARK: - Connection Monitor
    
    func connectionMonitor(connection: OSCConnection) {
        self.connection = connection
    }
    
    func connectionMonitor(ipAddress: String?) {}
}

// MARK: Client

extension OSC: OSCUdpClientDelegate {
    
    public func client(_ client: OSCUdpClient, didSendPacket packet: OSCPacket, fromHost host: String?, port: UInt16?) {}
    
    public func client(_ client: OSCUdpClient, didNotSendPacket packet: OSCPacket, fromHost host: String?, port: UInt16?, error: Error?) {
        if let error = error {
            print("SwiftUIOSC - UDP Client Did Not Send Packet with Error:", error)
        }
    }
    
    public func client(_ client: OSCUdpClient, socketDidCloseWithError error: Error) {
        print("SwiftUIOSC - UDP Client Socket Did Close with Error:", error)
    }
}

// MARK: Server

extension OSC: OSCUdpServerDelegate {
    
    public func server(_ server: OSCUdpServer, didReceivePacket packet: OSCPacket, fromHost host: String, port: UInt16) {
        if let message = packet as? OSCMessage {
            receive(message: message)
        } else if let bundle = packet as? OSCBundle {
            receive(bundle: bundle)
        }
    }
    
    public func server(_ server: OSCUdpServer, socketDidCloseWithError error: Error?) {
        if let error = error {
            print("SwiftUIOSC - UDP Server Socket Did Close with Error:", error)
        }
    }
    
    public func server(_ server: OSCUdpServer, didReadData data: Data, with error: Error) {
        print("SwiftUIOSC - UDP Server Did Read Data with Error:", error)
    }
}
