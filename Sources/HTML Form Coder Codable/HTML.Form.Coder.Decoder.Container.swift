import Foundation
public import HTML_Standard
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Decoder {
    public enum Container {
        indirect case keyed([String: Container])
        indirect case unkeyed([Container])
        case singleValue(String)

        package var params: [String: Container]? {
            switch self {
            case .keyed(let params):
                return params
            case .unkeyed, .singleValue:
                return nil
            }
        }

        package var values: [Container]? {
            switch self {
            case .unkeyed(let values):
                return values
            case .keyed, .singleValue:
                return nil
            }
        }

        package var value: String? {
            switch self {
            case .singleValue(let value):
                return value
            case .keyed, .unkeyed:
                return nil
            }
        }
    }
}

extension HTML.Form.Coder.Decoder.Container: CustomStringConvertible {
    public var description: String {
        switch self {
        case .keyed(let values):
            return "keyed(\(values))"
        case .unkeyed(let values):
            return "unkeyed(\(values))"
        case .singleValue(let value):
            return "singleValue(\(String(reflecting: value)))"
        }
    }
}
