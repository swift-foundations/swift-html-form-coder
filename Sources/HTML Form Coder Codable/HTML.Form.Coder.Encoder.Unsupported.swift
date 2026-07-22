import Foundation
public import HTML_Standard
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder {
    /// A stub encoder that throws errors on any operation.
    /// Used for unsupported superEncoder operations that cannot throw per protocol requirements.
    struct Unsupported: Swift.Encoder {
        let codingPath: [any CodingKey]
        let userInfo: [CodingUserInfoKey: Any] = [:]

        func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key>
        where Key: CodingKey {
            let container = Keyed<Key>(codingPath: self.codingPath)
            return KeyedEncodingContainer(container)
        }

        func unkeyedContainer() -> any UnkeyedEncodingContainer {
            return Unkeyed(codingPath: self.codingPath)
        }

        func singleValueContainer() -> any SingleValueEncodingContainer {
            return Single(codingPath: self.codingPath)
        }

    }
}
