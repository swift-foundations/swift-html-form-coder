import Foundation
public import HTML_Standard
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder.Unsupported {
    struct Unkeyed: UnkeyedEncodingContainer {
        let codingPath: [any CodingKey]
        var count: Int = 0

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

        mutating func nestedContainer<NestedKey>(
            keyedBy keyType: NestedKey.Type
        ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
            let container = Keyed<NestedKey>(codingPath: self.codingPath)
            return KeyedEncodingContainer(container)
        }

        mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
            return Unkeyed(codingPath: self.codingPath)
        }

        mutating func superEncoder() -> any Swift.Encoder {
            return HTML.Form.Coder.Encoder.Unsupported(codingPath: self.codingPath)
        }
    }
}
