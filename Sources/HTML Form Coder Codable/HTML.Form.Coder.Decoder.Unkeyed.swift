import Foundation
public import HTML_Standard
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Decoder {
    struct UnkeyedContainer: UnkeyedDecodingContainer {

        let decoder: HTML.Form.Coder.Decoder
        let container: [Container]

        private(set) var codingPath: [any CodingKey]
        var count: Int? {
            return self.container.count
        }
        var isAtEnd: Bool {
            return self.currentIndex >= self.container.count
        }
        private(set) var currentIndex: Int = 0

        init(decoder: HTML.Form.Coder.Decoder, container: [Container], codingPath: [any CodingKey]) {
            self.decoder = decoder
            self.container = container
            self.codingPath = codingPath
        }

        mutating private func checked<T>(_ block: (String) throws -> T) throws -> T {
            guard !self.isAtEnd else {
                throw Error.decodingError("Unkeyed container is at end", self.codingPath)
            }
            self.codingPath.append(Key(index: self.currentIndex))
            defer { self.codingPath.removeLast() }
            guard let container = self.decoder.unbox(self.container[self.currentIndex]) else {
                throw Error.decodingError(
                    "Expected \(T.self) at \(self.currentIndex), got nil",
                    self.codingPath
                )
            }
            let value = try block(container)
            self.currentIndex += 1
            return value
        }

        mutating private func unwrap<T>(_ block: (String) -> T?) throws -> T {
            guard let value = try self.checked(block) else {
                throw Error.decodingError(
                    "Expected \(T.self) at \(self.currentIndex), got nil",
                    self.codingPath
                )
            }
            return value
        }

        mutating func decodeNil() throws -> Bool {
            return try self.unwrap { $0.isEmpty }
        }

        mutating func decode(_ type: Bool.Type) throws -> Bool {
            return try self.unwrap(self.decoder.boolDecodingStrategy.decode)
        }

        mutating func decode(_ type: Int.Type) throws -> Int {
            return try self.unwrap(Int.init)
        }

        mutating func decode(_ type: Int8.Type) throws -> Int8 {
            return try self.unwrap(Int8.init)
        }

        mutating func decode(_ type: Int16.Type) throws -> Int16 {
            return try self.unwrap(Int16.init)
        }

        mutating func decode(_ type: Int32.Type) throws -> Int32 {
            return try self.unwrap(Int32.init)
        }

        mutating func decode(_ type: Int64.Type) throws -> Int64 {
            return try self.unwrap(Int64.init)
        }

        mutating func decode(_ type: UInt.Type) throws -> UInt {
            return try self.unwrap(UInt.init)
        }

        mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
            return try self.unwrap(UInt8.init)
        }

        mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
            return try self.unwrap(UInt16.init)
        }

        mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
            return try self.unwrap(UInt32.init)
        }

        mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
            return try self.unwrap(UInt64.init)
        }

        mutating func decode(_ type: Float.Type) throws -> Float {
            return try self.unwrap(Float.init)
        }

        mutating func decode(_ type: Double.Type) throws -> Double {
            return try self.unwrap(Double.init)
        }

        mutating func decode(_ type: String.Type) throws -> String {
            return try self.unwrap(id)
        }

        mutating func decode(_ type: Decimal.Type) throws -> Decimal {
            return try self.unwrap { Decimal(string: $0) ?? Decimal() }
        }

        mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
            guard !self.isAtEnd else {
                throw Error.decodingError("Unkeyed container is at end", self.codingPath)
            }
            self.codingPath.append(Key(index: self.currentIndex))
            defer { self.codingPath.removeLast() }
            let container = self.container[self.currentIndex]
            self.currentIndex += 1
            self.decoder.containers.append(container)
            defer { self.decoder.containers.removeLast() }
            return try self.decoder.unbox(container, as: T.self)
        }

        mutating func nestedContainer<NestedKey>(
            keyedBy type: NestedKey.Type
        ) throws
            -> KeyedDecodingContainer<NestedKey>
        where NestedKey: CodingKey {

            guard !self.isAtEnd else {
                throw Error.decodingError("Unkeyed container is at end", self.codingPath)
            }
            self.codingPath.append(Key(index: self.currentIndex))
            defer { self.codingPath.removeLast() }
            guard case .keyed(let container) = self.container[self.currentIndex] else {
                throw Error.decodingError(
                    "Expected value at \(self.currentIndex), got nil",
                    self.codingPath
                )
            }
            self.currentIndex += 1
            self.decoder.containers.append(.keyed(container))  // FIXME?
            defer { self.decoder.containers.removeLast() }
            return .init(KeyedContainer(decoder: self.decoder, container: container))
        }

        mutating func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
            guard !self.isAtEnd else {
                throw Error.decodingError("Unkeyed container is at end", self.codingPath)
            }
            self.codingPath.append(Key(index: self.currentIndex))
            defer { self.codingPath.removeLast() }
            guard case .unkeyed(let container) = self.container[self.currentIndex] else {
                throw Error.decodingError(
                    "Expected value at \(self.currentIndex), got nil",
                    self.codingPath
                )
            }
            self.currentIndex += 1
            self.decoder.containers.append(.unkeyed(container))  // FIXME?
            defer { self.decoder.containers.removeLast() }
            return UnkeyedContainer(
                decoder: self.decoder,
                container: container,
                codingPath: self.codingPath
            )
        }

        mutating func superDecoder() throws -> any Swift.Decoder {
            guard !self.isAtEnd else {
                throw Error.decodingError("Unkeyed container is at end", self.codingPath)
            }
            self.codingPath.append(Key(index: self.currentIndex))
            defer { self.codingPath.removeLast() }
            let container = self.container[self.currentIndex]
            self.currentIndex += 1
            let decoder = HTML.Form.Coder.Decoder()
            decoder.containers = [container]
            decoder.codingPath = self.codingPath
            decoder.dataDecodingStrategy = self.decoder.dataDecodingStrategy
            decoder.dateDecodingStrategy = self.decoder.dateDecodingStrategy
            decoder.arrayParsingStrategy = self.decoder.arrayParsingStrategy
            decoder.boolDecodingStrategy = self.decoder.boolDecodingStrategy
            return decoder
        }
    }
}
