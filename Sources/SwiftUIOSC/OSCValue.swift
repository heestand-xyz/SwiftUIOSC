import CoreGraphics

public protocol OSCArrayValue {
    var values: [Any] { get }
    static func convert(values: [Any]) -> Self
}
public protocol OSCValue: OSCArrayValue {
    static func convert(value: Any) -> Self
}
extension OSCValue {
    public var values: [Any] { [self] }
    public static func convert(values: [Any]) -> Self {
        let value: Any = values.first ?? false
        return convert(value: value)
    }
}

extension Bool: OSCValue {
    public static func convert(value: Any) -> Bool {
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
    public static func convert(value: Any) -> Int {
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
    public static func convert(value: Any) -> CGFloat {
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
    public static func convert(value: Any) -> Double {
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
    public static func convert(value: Any) -> String {
        value as? String ?? "#"
    }
}

extension CGPoint: OSCArrayValue {
    public var values: [Any] { [x, y] }
    public static func convert(values: [Any]) -> CGPoint {
        guard values.count == 2 else { return .zero }
        guard let value0: CGFloat = values[0] as? CGFloat else { return .zero }
        guard let value1: CGFloat = values[1] as? CGFloat else { return .zero }
        return CGPoint(x: value0, y: value1)
    }
}
extension CGSize: OSCArrayValue {
    public var values: [Any] { [width, height] }
    public static func convert(values: [Any]) -> CGSize {
        guard values.count == 2 else { return .zero }
        guard let value0: CGFloat = values[0] as? CGFloat else { return .zero }
        guard let value1: CGFloat = values[1] as? CGFloat else { return .zero }
        return CGSize(width: value0, height: value1)
    }
}
extension CGRect: OSCArrayValue {
    public var values: [Any] { [minX, minY, width, height] }
    public static func convert(values: [Any]) -> CGRect {
        guard values.count == 4 else { return .zero }
        guard let value0: CGFloat = values[0] as? CGFloat else { return .zero }
        guard let value1: CGFloat = values[1] as? CGFloat else { return .zero }
        guard let value2: CGFloat = values[2] as? CGFloat else { return .zero }
        guard let value3: CGFloat = values[3] as? CGFloat else { return .zero }
        return CGRect(x: value0, y: value1, width: value2, height: value3)
    }
}

//extension Array: OSCArrayValue where Element == OSCValue {
//    public var values: [Any] { self }
//    public static func convert(values: [Any]) -> OSCArrayValue {
//        values.map({ value -> T in
//            T.convert(value: value)
//        })
//    }
//}
