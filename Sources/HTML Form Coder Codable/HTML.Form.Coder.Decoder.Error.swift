import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Element.Form.Coder.Decoder {
    public enum Error: Swift.Error, CustomStringConvertible {
        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        case decodingError(String, [any CodingKey])

        public var description: String {
            switch self {
            case .decodingError(let message, let path):
                let pathString = path.map { $0.stringValue }.joined(separator: ".")
                let location = pathString.isEmpty ? "" : " at path '\(pathString)'"

                // Add helpful hints for common issues
                if message.contains("Expected Array") || message.contains("Expected unkeyed") {
                    return
                        "\(message)\(location). Hint: This might be a parsing strategy mismatch. Arrays encoded with 'bracketsWithIndices' (tags[0]=value) need to be decoded with the same strategy, not 'accumulateValues' (tags=value)."
                } else if message.contains("got nil")
                    && (pathString.contains("tags") || pathString.contains("items"))
                {
                    return
                        "\(message)\(location). Hint: Array fields may require matching encoding/decoding strategies. Check if encoder uses 'bracketsWithIndices' and decoder uses the same."
                } else {
                    return "\(message)\(location)"
                }
            }
        }
    }
}
