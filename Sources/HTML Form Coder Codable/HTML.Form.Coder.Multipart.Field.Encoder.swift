import Foundation
public import HTML_Form_Coder
public import HTML_Form_Coder_Multipart
public import HTML_Standard
import RFC_7578

extension HTML.Element.Form.Coder.Multipart.Field {
    final class Encoder: Swift.Encoder {
        var fields: [HTML.Element.Form.Coder.Multipart.Field] = []
        var files: [RFC_7578.Form.Data.File] = []
        let coder: HTML.Element.Form.Coder.Multipart.Encoder
        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        var codingPath: [any CodingKey] = []
        let userInfo: [CodingUserInfoKey: Any] = [:]

        init(coder: HTML.Element.Form.Coder.Multipart.Encoder) {
            self.coder = coder
        }

        func container<Key>(
            keyedBy type: Key.Type
        ) -> KeyedEncodingContainer<Key> where Key: CodingKey {
            KeyedEncodingContainer(
                HTML.Element.Form.Coder.Multipart.Keyed<Key>(encoder: self, codingPath: codingPath)
            )
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        func unkeyedContainer() -> any UnkeyedEncodingContainer {
            fatalError("root arrays are not representable as HTML form fields")
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        func singleValueContainer() -> any SingleValueEncodingContainer {
            HTML.Element.Form.Coder.Multipart.Single(encoder: self, codingPath: codingPath)
        }
    }
}
