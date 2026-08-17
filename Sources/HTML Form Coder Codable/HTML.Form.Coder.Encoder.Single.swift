import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Element.Form.Coder.Encoder {
    struct SingleValueContainer: SingleValueEncodingContainer {
        private let encoder: HTML.Element.Form.Coder.Encoder

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        var codingPath: [any CodingKey] = []

        init(encoder: HTML.Element.Form.Coder.Encoder) {
            self.encoder = encoder
        }

        mutating func encodeNil() {
            self.encoder.container = .singleValue("")
        }

        mutating func encode(_ value: Bool) {
            encode(self.encoder.boolEncodingStrategy.encode(value))
        }

        mutating func encode(_ value: String) {
            let encoded = WHATWG_Form_URL_Encoded.PercentEncoding.encode(
                value,
                space: .plus
            )
            self.encoder.container = .singleValue(encoded)
        }

        mutating func encode(_ value: Double) {
            encode(String(value))
        }

        mutating func encode(_ value: Float) {
            encode(String(value))
        }

        mutating func encode(_ value: Int) {
            encode(String(value))
        }

        mutating func encode(_ value: Int8) {
            encode(String(value))
        }

        mutating func encode(_ value: Int16) {
            encode(String(value))
        }

        mutating func encode(_ value: Int32) {
            encode(String(value))
        }

        mutating func encode(_ value: Int64) {
            encode(String(value))
        }

        mutating func encode(_ value: UInt) {
            encode(String(value))
        }

        mutating func encode(_ value: UInt8) {
            encode(String(value))
        }

        mutating func encode(_ value: UInt16) {
            encode(String(value))
        }

        mutating func encode(_ value: UInt32) {
            encode(String(value))
        }

        mutating func encode(_ value: UInt64) {
            encode(String(value))
        }

        mutating func encode<T>(_ value: T) throws(HTML.Element.Form.Coder.Encoder.Error)
        where T: Encodable {
            if let strValue = value as? String {
                encode(strValue)
            } else {
                // Instead of using String(describing:) which can fail for certain types,
                // we need to properly encode the value through the encoder
                self.encoder.container = try self.encoder.box(value)
            }
        }
    }
}
