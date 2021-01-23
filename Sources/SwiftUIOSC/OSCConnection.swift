import Foundation
import Reachability
#if os(iOS)
import UIKit
#endif

public enum OSCConnection {
    case unknown
    case offline
    case wifi
    case cellular
    var connected: Bool {
        [.wifi, .cellular].contains(self)
    }
}

protocol OSCConnectionMonitorDelegate: AnyObject {
    func connectionMonitor(connection: OSCConnection)
    func connectionMonitor(ipAddress: String?)
}

class OSCConnectionMonitor {
    
    weak var delegate: OSCConnectionMonitorDelegate?
    
    var connection: OSCConnection = .unknown {
        didSet { delegate?.connectionMonitor(connection: connection) }
    }
    var ipAddress: String? {
        didSet { delegate?.connectionMonitor(ipAddress: ipAddress) }
    }
    
    var reachability: Reachability?
    
    // MARK: - Life Cycle
    
    init() {
        
        do {
            reachability = try Reachability()
        } catch {
            print("Connection - Unable to init Reachability.")
        }
        
        monitor()
        
    }
    
    // MARK: - App State
    
    #if os(iOS)

    func listenToApp() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }
    
    @objc func didBecomeActive() {
        monitor()
    }
    
    @objc func willResignActive() {}
    
    @objc func willEnterForeground() {}
    
    @objc func didEnterBackground() {}

    #endif
    
    // MARK: - Monitor
    
    func monitor() {
        
        ipAddress = getIPAddress()
        
        reachability?.whenReachable = { reachability in
            switch reachability.connection {
            case .none, .unavailable:
                self.connection = .unknown
            case .wifi:
                self.connection = .wifi
            case .cellular:
                self.connection = .cellular
            }
            self.ipAddress = self.getIPAddress()
        }
        reachability?.whenUnreachable = { _ in
            self.connection = .offline
            self.ipAddress = nil
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Connection - Unable to start notifier.")
        }
        
    }
    
    func stop() {
        reachability?.stopNotifier()
    }
    
    // MARK: - IP Addresses
    
    func getIPAddress() -> String? {
        let addresses = getIPAddresses()
        var ipAddress: String?
        let targets: [String] = ["192", "172", "127", "10"]
        loop: for target in targets {
            for address in addresses {
                let address_components = address.components(separatedBy: ".")
                if address_components.first == target {
                    ipAddress = address
                    break loop
                }
            }
        }
        return ipAddress ?? addresses.first
    }
    
    func getIPAddresses() -> [String] {
        
        var addresses = [String]()

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }

        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee

            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }

        freeifaddrs(ifaddr)
        
        return addresses
    }
    
}
