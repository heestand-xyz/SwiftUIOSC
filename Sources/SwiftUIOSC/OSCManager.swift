import Foundation
import OSCTools2
import OSCKit

public struct OSCManager {
    
    public static let osc = OSC()
    
    // MARK: - Register
    
    static func register<T: OSCArray>(oscState: OSCState<T>) {
        osc.backgroundListenToAnyArray {
            oscState.address
        } _: { values in
            guard let values = values as? [any OSCValue] else {
                print("SwiftUIOSC - Type conversion failed.")
                return
            }
            let value: T = .convert(values: values)
            oscState.receiving = true
            oscState.value = value
            oscState.receiving = false
        }
    }
    
    // MARK: - Send
    
    static func send(_ oscArrayValues: OSCArray, at address: String) {
        let values: [any OSCValue] = oscArrayValues.values
        var address: String = address
        if address.first != "/" {
            address = "/\(address)"
        }
        osc.send(values: values, address: address)
    }
}
