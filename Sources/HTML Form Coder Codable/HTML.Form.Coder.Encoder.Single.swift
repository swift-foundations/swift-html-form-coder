import Foundation
public import HTML_Standard
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder {
    struct SingleValueContainer: SingleValueEncodingContainer {
        private let encoder: HTML.Form.Coder.Encoder

        var codingPath: [any CodingKey] = []

        init(encoder: HTML.Form.Coder.Encoder) {
            self.encoder = encoder
        }

        mutating func encodeNil() throws {
            self.encoder.container = .singleValue("")
        }

        mutating func encode(_ value: Bool) throws {
            try encode(self.encoder.boolEncodingStrategy.encode(value))
        }

        mutating func encode(_ value: String) throws {
            let encoded = WHATWG_Form_URL_Encoded.PercentEncoding.encode(
                value,
                space: .plus
            )
            self.encoder.container = .singleValue(encoded)
        }

        mutating func encode(_ value: Double) throws {
            try encode(String(value))
        }

        mutating func encode(_ value: Float) throws {
            try encode(String(value))
        }

        mutating func encode(_ value: Int) throws {
            try encode(String(value))
        }

        mutating func encode(_ value: Int8) throws {
            try encode(String(value))
        }

        mutating func encode(_ value: Int16) throws {
            try encode(String(value))
        }

        mutating func encode(_ value: Int32) throws {
            try encode(String(value))
        }

        mutating func encode(_ value: Int64) throws {
            try encode(String(value))
        }

        mutating func encode(_ value: UInt) throws {
            try encode(String(value))
        }

        mutating func encode(_ value: UInt8) throws {
            try encode(String(value))
        }

        mutating func encode(_ value: UInt16) throws {
            try encode(String(value))
        }

        mutating func encode(_ value: UInt32) throws {
            try encode(String(value))
        }

        mutating func encode(_ value: UInt64) throws {
            try encode(String(value))
        }

        mutating func encode<T>(_ value: T) throws where T: Encodable {
            if let strValue = value as? String {
                try encode(strValue)
            } else {
                // Instead of using String(describing:) which can fail for certain types,
                // we need to properly encode the value through the encoder
                self.encoder.container = try self.encoder.box(value)
            }
        }
    }
}
