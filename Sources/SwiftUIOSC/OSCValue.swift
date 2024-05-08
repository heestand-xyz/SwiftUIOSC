import CoreGraphics
import OSCKit

public protocol OSCArray {
    var values: [AnyOSCValue] { get }
    static func convert(values: [AnyOSCValue]) -> Self
}

public protocol OSCElement: OSCArray, OSCValue {
    static func convert(value: AnyOSCValue) -> Self
}

extension OSCElement {
    public var values: [AnyOSCValue] { [self] }
    public static func convert(values: [AnyOSCValue]) -> Self {
        let value: AnyOSCValue = values.first ?? false
        return convert(value: value)
    }
}

extension Bool: OSCElement {
    public static func convert(value: AnyOSCValue) -> Bool {
        if let bool = value as? Bool {
            return bool
        } else if let int = value as? Int {
            return int > 0
        } else if let float = value as? Float {
            return float > 0.0
        } else if let string = value as? String {
            return ["true", "True", "1"].contains(string)
        }
        return false
    }
}

extension Int: OSCElement {
    public static func convert(value: AnyOSCValue) -> Int {
        if let bool = value as? Bool {
            return bool ? 1 : 0
        } else if let int = value as? Int {
            return int
        } else if let float = value as? Float {
            return Int(float)
        } else if let string = value as? String {
            return Int(string) ?? 0
        }
        return -1
    }
}

extension CGFloat: OSCElement {
    public static func convert(value: AnyOSCValue) -> CGFloat {
        if let bool = value as? Bool {
            return bool ? 1.0 : 0.0
        } else if let int = value as? Int {
            return CGFloat(int)
        } else if let float = value as? Float {
            return CGFloat(float)
        } else if let string = value as? String {
            return CGFloat(Double(string) ?? 0.0)
        }
        return -1.0
    }
}

extension Double: OSCElement {
    public static func convert(value: AnyOSCValue) -> Double {
        if let bool = value as? Bool {
            return bool ? 1.0 : 0.0
        } else if let int = value as? Int {
            return Double(int)
        } else if let float = value as? Float {
            return Double(float)
        } else if let string = value as? String {
            return Double(string) ?? 0.0
        }
        return -1.0
    }
}

extension String: OSCElement {
    public static func convert(value: AnyOSCValue) -> String {
        value as? String ?? "#"
    }
}

extension CGPoint: OSCArray {
    public var values: [AnyOSCValue] { [x, y] }
    public static func convert(values: [AnyOSCValue]) -> CGPoint {
        guard values.count == 2 else { return .zero }
        guard let value0: CGFloat = values[0] as? CGFloat else { return .zero }
        guard let value1: CGFloat = values[1] as? CGFloat else { return .zero }
        return CGPoint(x: value0, y: value1)
    }
}

extension CGSize: OSCArray {
    public var values: [AnyOSCValue] { [width, height] }
    public static func convert(values: [AnyOSCValue]) -> CGSize {
        guard values.count == 2 else { return .zero }
        guard let value0: CGFloat = values[0] as? CGFloat else { return .zero }
        guard let value1: CGFloat = values[1] as? CGFloat else { return .zero }
        return CGSize(width: value0, height: value1)
    }
}

extension CGRect: OSCArray {
    public var values: [AnyOSCValue] { [minX, minY, width, height] }
    public static func convert(values: [AnyOSCValue]) -> CGRect {
        guard values.count == 4 else { return .zero }
        guard let value0: CGFloat = values[0] as? CGFloat else { return .zero }
        guard let value1: CGFloat = values[1] as? CGFloat else { return .zero }
        guard let value2: CGFloat = values[2] as? CGFloat else { return .zero }
        guard let value3: CGFloat = values[3] as? CGFloat else { return .zero }
        return CGRect(x: value0, y: value1, width: value2, height: value3)
    }
}
