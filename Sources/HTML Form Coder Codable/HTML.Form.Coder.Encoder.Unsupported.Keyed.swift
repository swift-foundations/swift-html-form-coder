import Foundation
public import HTML_Standard
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder.Unsupported {
    struct Keyed<Key: CodingKey>: KeyedEncodingContainerProtocol {
        let codingPath: [any CodingKey]

        mutating func encodeNil(forKey key: Key) throws {
            throw HTML.Form.Coder.Encoder.Error.encodingError(
                "superEncoder() is not supported in URL form encoding",
                self.codingPath
            )
        }

        mutating func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
            throw HTML.Form.Coder.Encoder.Error.encodingError(
                "superEncoder() is not supported in URL form encoding",
                self.codingPath
            )
        }

        mutating func nestedContainer<NestedKey>(
            keyedBy keyType: NestedKey.Type,
            forKey key: Key
        ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
            let container = Keyed<NestedKey>(
                codingPath: self.codingPath + [key]
            )
            return KeyedEncodingContainer(container)
        }

        mutating func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
            return Unkeyed(codingPath: self.codingPath + [key])
        }

        mutating func superEncoder() -> any Swift.Encoder {
            return HTML.Form.Coder.Encoder.Unsupported(codingPath: self.codingPath)
        }

        mutating func superEncoder(forKey key: Key) -> any Swift.Encoder {
            return HTML.Form.Coder.Encoder.Unsupported(codingPath: self.codingPath + [key])
        }
    }
}
