import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Element.Form.Coder.Encoder.Unsupported {
    struct Single: SingleValueEncodingContainer {
        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        let codingPath: [any CodingKey]

        mutating func encodeNil() throws(HTML.Element.Form.Coder.Encoder.Error) {
            throw HTML.Element.Form.Coder.Encoder.Error.encodingError(
                "superEncoder() is not supported in URL form encoding",
                self.codingPath
            )
        }

        mutating func encode<T>(_ value: T) throws(HTML.Element.Form.Coder.Encoder.Error)
        where T: Encodable {
            throw HTML.Element.Form.Coder.Encoder.Error.encodingError(
                "superEncoder() is not supported in URL form encoding",
                self.codingPath
            )
        }
    }
}
