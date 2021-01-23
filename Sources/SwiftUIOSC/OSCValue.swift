import CoreGraphics

public protocol OSCArrayValue {
    var values: [Any] { get }
}
public protocol OSCValue: OSCArrayValue {}
extension OSCValue {
    public var values: [Any] { [self] }
}

extension Bool: OSCValue {}
extension Int: OSCValue {}
extension CGFloat: OSCValue {}
extension Double: OSCValue {}
extension String: OSCValue {}

extension CGPoint: OSCArrayValue {
    public var values: [Any] { [x, y] }
}
extension CGSize: OSCArrayValue {
    public var values: [Any] { [width, height] }
}
extension CGRect: OSCArrayValue {
    public var values: [Any] { [minX, minY, width, height] }
}

extension Array: OSCArrayValue where Element == OSCValue {
    public var values: [Any] { self }
}
