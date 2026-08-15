import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder {
    /// A stub encoder that throws errors on any operation.
    /// Used for unsupported superEncoder operations that cannot throw per protocol requirements.
    struct Unsupported: Swift.Encoder {
        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        let codingPath: [any CodingKey]
        let userInfo: [CodingUserInfoKey: Any] = [:]

        func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key>
        where Key: CodingKey {
            let container = Keyed<Key>(codingPath: self.codingPath)
            return KeyedEncodingContainer(container)
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        func unkeyedContainer() -> any UnkeyedEncodingContainer {
            return Unkeyed(codingPath: self.codingPath)
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        func singleValueContainer() -> any SingleValueEncodingContainer {
            return Single(codingPath: self.codingPath)
        }

    }
}
