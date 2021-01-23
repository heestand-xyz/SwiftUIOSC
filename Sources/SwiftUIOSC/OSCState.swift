import SwiftUI

@propertyWrapper
public struct OSCState<T: OSCArrayValue>: DynamicProperty {
    
    let address: String
    
    @State var value: T {
        didSet {
            OSC.shared.send(value, at: address)
        }
    }
    
    public var wrappedValue: T {
        get {
            value
        }
        nonmutating set {
            value = newValue
        }
    }
    
    public var projectedValue: Binding<T> {
        Binding<T> {
            self.value
        } set: { value in
            self.value = value
        }
    }
    
    public init(wrappedValue: T, name address: String) {
        self.address = address
        _value = State(wrappedValue: wrappedValue)
    }
    
}
