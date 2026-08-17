import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder {
    struct KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
        private let encoder: HTML.Form.Coder.Encoder

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        var codingPath: [any CodingKey] {
            return self.encoder.codingPath
        }

        init(encoder: HTML.Form.Coder.Encoder) {
            self.encoder = encoder
        }

        mutating func encodeNil(forKey key: Key) {
            var container = self.encoder.container?.params ?? [:]
            container[key.stringValue] = .singleValue("")
            self.encoder.container = .keyed(container)
        }

        mutating func encode<T>(
            _ value: T,
            forKey key: Key
        ) throws(HTML.Form.Coder.Encoder.Error) where T: Encodable {
            self.encoder.codingPath.append(key)
            defer { self.encoder.codingPath.removeLast() }
            var container = self.encoder.container?.params ?? [:]
            container[key.stringValue] = try self.encoder.box(value)
            self.encoder.container = .keyed(container)
        }

        mutating func nestedContainer<NestedKey>(
            keyedBy keyType: NestedKey.Type,
            forKey key: Key
        ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
            self.encoder.codingPath.append(key)
            defer { self.encoder.codingPath.removeLast() }
            let container = KeyedContainer<NestedKey>(encoder: self.encoder)
            var params = self.encoder.container?.params ?? [:]
            params[key.stringValue] = .keyed([:])
            self.encoder.container = .keyed(params)
            return KeyedEncodingContainer(container)
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        mutating func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
            self.encoder.codingPath.append(key)
            defer { self.encoder.codingPath.removeLast() }
            let container = UnkeyedContainer(encoder: self.encoder)
            var params = self.encoder.container?.params ?? [:]
            params[key.stringValue] = .unkeyed([])
            self.encoder.container = .keyed(params)
            return container
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        mutating func superEncoder() -> any Swift.Encoder {
            return Unsupported(codingPath: self.codingPath)
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        mutating func superEncoder(forKey key: Key) -> any Swift.Encoder {
            return Unsupported(codingPath: self.codingPath + [key])
        }
    }
}
