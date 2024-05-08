import Observation
import SwiftUI

@propertyWrapper
@Observable
public class OSCState<T: OSCArray> {
    
    let address: String
    
    var receiving: Bool = false
    
    public var wrappedValue: T {
        didSet {
            if receiving { return }
            OSCManager.send(wrappedValue, at: address)
        }
    }
    
    public var osc: T {
        get {
            wrappedValue
        }
        set {
            wrappedValue = newValue
        }
    }
    
    public init(wrappedValue: T, address: String) {
        self.address = address
        self.wrappedValue = wrappedValue
        OSCManager.register(oscState: self)
    }
}
