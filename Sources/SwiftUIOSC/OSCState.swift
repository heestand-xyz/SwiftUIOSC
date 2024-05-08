import SwiftUI

@propertyWrapper
public class OSCState<T: OSCArray> {
    
    let address: String
    
    var receiving: Bool = false
    
    public var wrappedValue: T {
        didSet {
            if receiving { return }
            OSCManager.send(wrappedValue, at: address)
        }
    }
    
    public var projectedValue: Binding<T> {
        Binding<T> { [unowned self] in
            return self.wrappedValue
        } set: { [weak self] value in
            self?.wrappedValue = value
        }
    }
        
    public init(wrappedValue: T, name address: String) {
        self.address = address
        self.wrappedValue = wrappedValue
        OSCManager.register(oscState: self)
    }
}
