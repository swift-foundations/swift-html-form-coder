import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder {
    struct UnkeyedContainer: UnkeyedEncodingContainer {
        private let encoder: HTML.Form.Coder.Encoder

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        var codingPath: [any CodingKey] {
            return self.encoder.codingPath
        }

        var count: Int {
            return self.encoder.container?.values?.count ?? 0
        }

        init(encoder: HTML.Form.Coder.Encoder) {
            self.encoder = encoder
        }

        mutating func encodeNil() {
            var values = self.encoder.container?.values ?? []
            values.append(.singleValue(""))
            self.encoder.container = .unkeyed(values)
        }

        mutating func encode<T>(_ value: T) throws(HTML.Form.Coder.Encoder.Error)
        where T: Encodable {
            var values = self.encoder.container?.values ?? []
            values.append(try self.encoder.box(value))
            self.encoder.container = .unkeyed(values)
        }

        mutating func nestedContainer<NestedKey>(
            keyedBy keyType: NestedKey.Type
        ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
            let container = KeyedContainer<NestedKey>(encoder: self.encoder)
            var values = self.encoder.container?.values ?? []
            values.append(.keyed([:]))
            self.encoder.container = .unkeyed(values)
            return KeyedEncodingContainer(container)
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
            let container = UnkeyedContainer(encoder: self.encoder)
            var values = self.encoder.container?.values ?? []
            values.append(.unkeyed([]))
            self.encoder.container = .unkeyed(values)
            return container
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        mutating func superEncoder() -> any Swift.Encoder {
            return Unsupported(codingPath: self.codingPath)
        }
    }
}
