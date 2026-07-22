import Foundation
public import HTML_Standard
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder.Unsupported {
    struct Single: SingleValueEncodingContainer {
        let codingPath: [any CodingKey]

        mutating func encodeNil() throws {
            throw HTML.Form.Coder.Encoder.Error.encodingError(
                "superEncoder() is not supported in URL form encoding",
                self.codingPath
            )
        }

        mutating func encode<T>(_ value: T) throws where T: Encodable {
            throw HTML.Form.Coder.Encoder.Error.encodingError(
                "superEncoder() is not supported in URL form encoding",
                self.codingPath
            )
        }
    }
}
