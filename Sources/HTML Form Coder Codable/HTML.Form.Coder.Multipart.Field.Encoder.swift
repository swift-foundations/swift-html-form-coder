import Foundation
public import HTML_Standard
public import HTML_Form_Coder
public import HTML_Form_Coder_Multipart
import RFC_7578

extension HTML.Form.Coder.Multipart.Field {
    final class Encoder: Swift.Encoder {
        var fields: [HTML.Form.Coder.Multipart.Field] = []
        var files: [RFC_7578.Form.Data.File] = []
        let coder: HTML.Form.Coder.Multipart.Encoder
        var codingPath: [any CodingKey] = []
        let userInfo: [CodingUserInfoKey: Any] = [:]

        init(coder: HTML.Form.Coder.Multipart.Encoder) {
            self.coder = coder
        }

        func container<Key>(
            keyedBy type: Key.Type
        ) -> KeyedEncodingContainer<Key> where Key: CodingKey {
            KeyedEncodingContainer(
                HTML.Form.Coder.Multipart.Keyed<Key>(encoder: self, codingPath: codingPath)
            )
        }

        func unkeyedContainer() -> any UnkeyedEncodingContainer {
            fatalError("root arrays are not representable as HTML form fields")
        }

        func singleValueContainer() -> any SingleValueEncodingContainer {
            HTML.Form.Coder.Multipart.Single(encoder: self, codingPath: codingPath)
        }
    }
}
