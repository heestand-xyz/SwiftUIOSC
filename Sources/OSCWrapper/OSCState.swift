import SwiftUI

@propertyWrapper
public struct OSCState<T: OSCValue>: DynamicProperty {
    
    let address: String
    
    @State var value: T {
        didSet {
            OSCWrapper.shared.send(value: value, at: address)
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
    
//    public var osc: Binding<T>!
    
    public init(wrappedValue: T, as address: String) {
        self.address = address
        _value = State(wrappedValue: wrappedValue)
//        osc = Binding<T>(get: {
//            self.wrappedValue
//        }, set: { value in
//            self.wrappedValue = value
//        })
    }
    
}
