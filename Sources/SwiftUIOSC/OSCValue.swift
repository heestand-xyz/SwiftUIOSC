import CoreGraphics
import OSCKit

public protocol OSCArrayValue {
    var values: [OSCArgumentProtocol] { get }
    static func convert(values: [OSCArgumentProtocol]) -> Self
}

public protocol OSCValue: OSCArrayValue, OSCArgumentProtocol {
    static func convert(value: OSCArgumentProtocol) -> Self
}
extension OSCValue {
    public var values: [OSCArgumentProtocol] { [self] }
    public static func convert(values: [OSCArgumentProtocol]) -> Self {
        let value: OSCArgumentProtocol = values.first ?? false
        return convert(value: value)
    }
}

extension Bool: OSCValue {
    public static func convert(value: OSCArgumentProtocol) -> Bool {
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
extension Int: OSCValue {
    public static func convert(value: OSCArgumentProtocol) -> Int {
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
extension CGFloat: OSCValue {
    public static func convert(value: OSCArgumentProtocol) -> CGFloat {
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
extension Double: OSCValue {
    public static func convert(value: OSCArgumentProtocol) -> Double {
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
extension String: OSCValue {
    public static func convert(value: OSCArgumentProtocol) -> String {
        value as? String ?? "#"
    }
}

extension CGPoint: OSCArrayValue {
    public var values: [OSCArgumentProtocol] { [x, y] }
    public static func convert(values: [OSCArgumentProtocol]) -> CGPoint {
        guard values.count == 2 else { return .zero }
        guard let value0: CGFloat = values[0] as? CGFloat else { return .zero }
        guard let value1: CGFloat = values[1] as? CGFloat else { return .zero }
        return CGPoint(x: value0, y: value1)
    }
}
extension CGSize: OSCArrayValue {
    public var values: [OSCArgumentProtocol] { [width, height] }
    public static func convert(values: [OSCArgumentProtocol]) -> CGSize {
        guard values.count == 2 else { return .zero }
        guard let value0: CGFloat = values[0] as? CGFloat else { return .zero }
        guard let value1: CGFloat = values[1] as? CGFloat else { return .zero }
        return CGSize(width: value0, height: value1)
    }
}
extension CGRect: OSCArrayValue {
    public var values: [OSCArgumentProtocol] { [minX, minY, width, height] }
    public static func convert(values: [OSCArgumentProtocol]) -> CGRect {
        guard values.count == 4 else { return .zero }
        guard let value0: CGFloat = values[0] as? CGFloat else { return .zero }
        guard let value1: CGFloat = values[1] as? CGFloat else { return .zero }
        guard let value2: CGFloat = values[2] as? CGFloat else { return .zero }
        guard let value3: CGFloat = values[3] as? CGFloat else { return .zero }
        return CGRect(x: value0, y: value1, width: value2, height: value3)
    }
}
