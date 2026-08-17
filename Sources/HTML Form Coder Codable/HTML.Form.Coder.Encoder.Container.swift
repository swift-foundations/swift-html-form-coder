import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder {
    public enum Container {
        indirect case keyed([String: Container])
        indirect case unkeyed([Container])
        case singleValue(String)

        var params: [String: Container]? {
            switch self {
            case .keyed(let params):
                return params

            case .unkeyed, .singleValue:
                return nil
            }
        }

        var values: [Container]? {
            switch self {
            case .unkeyed(let values):
                return values

            case .keyed, .singleValue:
                return nil
            }
        }

        var value: String? {
            switch self {
            case .singleValue(let value):
                return value

            case .keyed, .unkeyed:
                return nil
            }
        }
    }
}
