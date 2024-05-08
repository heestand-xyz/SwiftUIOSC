import SwiftUI

@propertyWrapper
public struct OSCState<T: OSCArray>: DynamicProperty {
    
    let address: String
    
    @State var receiving: Bool = false
    
    @State var value: T {
        didSet {
            if receiving { return }
            OSCManager.send(value, at: address)
        }
    }
    
    public var wrappedValue: T {
        get {
            return value
        }
        nonmutating set {
            value = newValue
        }
    }
    
    public var projectedValue: Binding<T> {
        Binding<T> {
            return self.value
        } set: { value in
            self.value = value
        }
    }
        
    public init(wrappedValue: T, name address: String) {
        self.address = address
        _value = State(wrappedValue: wrappedValue)
        OSCManager.register(oscState: self)
    }
    
}
