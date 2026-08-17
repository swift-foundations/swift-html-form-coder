import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Element.Form.Coder.Decoder {
    struct SingleValueContainer: SingleValueDecodingContainer {
        let decoder: HTML.Element.Form.Coder.Decoder
        let container: Container

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        let codingPath: [any CodingKey] = []

        private func unwrap<T>(_ block: (String) -> T?, _ line: UInt = #line) throws(Error) -> T {
            guard
                case .singleValue(let container) = self.container,
                let value = block(container)
            else { throw Error.decodingError("Expected \(T.self), got nil", self.codingPath) }

            return value
        }

        func decodeNil() -> Bool {
            switch self.container {
            case .singleValue(let string):
                return string.isEmpty

            default:
                return false
            }
        }

        func decode(_ type: Bool.Type) throws(Error) -> Bool {
            return try self.unwrap(self.decoder.boolDecodingStrategy.decode)
        }

        func decode(_ type: Int.Type) throws(Error) -> Int {
            return try self.unwrap(Int.init)
        }

        func decode(_ type: Int8.Type) throws(Error) -> Int8 {
            return try self.unwrap(Int8.init)
        }

        func decode(_ type: Int16.Type) throws(Error) -> Int16 {
            return try self.unwrap(Int16.init)
        }

        func decode(_ type: Int32.Type) throws(Error) -> Int32 {
            return try self.unwrap(Int32.init)
        }

        func decode(_ type: Int64.Type) throws(Error) -> Int64 {
            return try self.unwrap(Int64.init)
        }

        func decode(_ type: UInt.Type) throws(Error) -> UInt {
            return try self.unwrap(UInt.init)
        }

        func decode(_ type: UInt8.Type) throws(Error) -> UInt8 {
            return try self.unwrap(UInt8.init)
        }

        func decode(_ type: UInt16.Type) throws(Error) -> UInt16 {
            return try self.unwrap(UInt16.init)
        }

        func decode(_ type: UInt32.Type) throws(Error) -> UInt32 {
            return try self.unwrap(UInt32.init)
        }

        func decode(_ type: UInt64.Type) throws(Error) -> UInt64 {
            return try self.unwrap(UInt64.init)
        }

        func decode(_ type: Float.Type) throws(Error) -> Float {
            return try self.unwrap(Float.init)
        }

        func decode(_ type: Double.Type) throws(Error) -> Double {
            return try self.unwrap(Double.init)
        }

        func decode(_ type: String.Type) throws(Error) -> String {
            return try self.unwrap(id)
        }

        func decode(_ type: Decimal.Type) throws(Error) -> Decimal {
            return try self.unwrap { Decimal(string: $0) ?? Decimal() }
        }

        func decode<T>(_ type: T.Type) throws(Error) -> T where T: Decodable {
            self.decoder.containers.append(self.container)
            defer { self.decoder.containers.removeLast() }
            return try self.decoder.unbox(self.container, as: T.self)
        }
    }
}
