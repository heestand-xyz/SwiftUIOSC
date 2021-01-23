import CoreGraphics

public protocol OSCValue {}

extension Bool: OSCValue {}
extension Int: OSCValue {}
extension CGFloat: OSCValue {}
extension Double: OSCValue {}
extension String: OSCValue {}
