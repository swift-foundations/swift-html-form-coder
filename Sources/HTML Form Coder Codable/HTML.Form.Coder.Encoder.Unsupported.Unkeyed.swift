import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder.Unsupported {
    struct Unkeyed: UnkeyedEncodingContainer {
        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        let codingPath: [any CodingKey]
        var count: Int = 0

        mutating func encodeNil() throws(HTML.Form.Coder.Encoder.Error) {
            throw HTML.Form.Coder.Encoder.Error.encodingError(
                "superEncoder() is not supported in URL form encoding",
                self.codingPath
            )
        }

        mutating func encode<T>(_ value: T) throws(HTML.Form.Coder.Encoder.Error)
        where T: Encodable {
            throw HTML.Form.Coder.Encoder.Error.encodingError(
                "superEncoder() is not supported in URL form encoding",
                self.codingPath
            )
        }

        mutating func nestedContainer<NestedKey>(
            keyedBy keyType: NestedKey.Type
        ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
            let container = Keyed<NestedKey>(codingPath: self.codingPath)
            return KeyedEncodingContainer(container)
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
            return Unkeyed(codingPath: self.codingPath)
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        mutating func superEncoder() -> any Swift.Encoder {
            return HTML.Form.Coder.Encoder.Unsupported(codingPath: self.codingPath)
        }
    }
}
