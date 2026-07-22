import Foundation
public import HTML_Standard
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder {
    public enum Error: Swift.Error, CustomStringConvertible {
        case encodingError(String, [any CodingKey])

        public var description: String {
            switch self {
            case .encodingError(let message, let path):
                let pathString = path.map { $0.stringValue }.joined(separator: ".")
                let location = pathString.isEmpty ? "" : " at path '\(pathString)'"
                return "\(message)\(location)"
            }
        }
    }
}
