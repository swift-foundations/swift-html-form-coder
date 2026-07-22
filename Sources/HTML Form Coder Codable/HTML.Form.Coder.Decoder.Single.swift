import Foundation
public import HTML_Standard
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Decoder {
    struct SingleValueContainer: SingleValueDecodingContainer {
        let decoder: HTML.Form.Coder.Decoder
        let container: Container

        let codingPath: [any CodingKey] = []

        private func unwrap<T>(_ block: (String) -> T?, _ line: UInt = #line) throws -> T {
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

        func decode(_ type: Bool.Type) throws -> Bool {
            return try self.unwrap(self.decoder.boolDecodingStrategy.decode)
        }

        func decode(_ type: Int.Type) throws -> Int {
            return try self.unwrap(Int.init)
        }

        func decode(_ type: Int8.Type) throws -> Int8 {
            return try self.unwrap(Int8.init)
        }

        func decode(_ type: Int16.Type) throws -> Int16 {
            return try self.unwrap(Int16.init)
        }

        func decode(_ type: Int32.Type) throws -> Int32 {
            return try self.unwrap(Int32.init)
        }

        func decode(_ type: Int64.Type) throws -> Int64 {
            return try self.unwrap(Int64.init)
        }

        func decode(_ type: UInt.Type) throws -> UInt {
            return try self.unwrap(UInt.init)
        }

        func decode(_ type: UInt8.Type) throws -> UInt8 {
            return try self.unwrap(UInt8.init)
        }

        func decode(_ type: UInt16.Type) throws -> UInt16 {
            return try self.unwrap(UInt16.init)
        }

        func decode(_ type: UInt32.Type) throws -> UInt32 {
            return try self.unwrap(UInt32.init)
        }

        func decode(_ type: UInt64.Type) throws -> UInt64 {
            return try self.unwrap(UInt64.init)
        }

        func decode(_ type: Float.Type) throws -> Float {
            return try self.unwrap(Float.init)
        }

        func decode(_ type: Double.Type) throws -> Double {
            return try self.unwrap(Double.init)
        }

        func decode(_ type: String.Type) throws -> String {
            return try self.unwrap(id)
        }

        func decode(_ type: Decimal.Type) throws -> Decimal {
            return try self.unwrap { Decimal(string: $0) ?? Decimal() }
        }

        func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
            self.decoder.containers.append(self.container)
            defer { self.decoder.containers.removeLast() }
            return try self.decoder.unbox(self.container, as: T.self)
        }
    }
}
