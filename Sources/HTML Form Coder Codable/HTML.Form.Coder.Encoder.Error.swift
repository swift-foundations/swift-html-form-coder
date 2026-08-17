import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Element.Form.Coder.Encoder {
    public enum Error: Swift.Error, CustomStringConvertible {
        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
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
