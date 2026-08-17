import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Decoder {
    struct UnkeyedContainer: UnkeyedDecodingContainer {

        let decoder: HTML.Form.Coder.Decoder
        let container: [Container]

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        private(set) var codingPath: [any CodingKey]
        var count: Int? {
            return self.container.count
        }
        var isAtEnd: Bool {
            return self.currentIndex >= self.container.count
        }
        private(set) var currentIndex: Int = 0

        init(
            decoder: HTML.Form.Coder.Decoder,
            container: [Container],
            // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
            // swiftlint:disable:next no_any_protocol_existential
            codingPath: [any CodingKey]
        ) {
            self.decoder = decoder
            self.container = container
            self.codingPath = codingPath
        }

        private mutating func checked<T>(_ block: (String) throws(Error) -> T) throws(Error) -> T {
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

        private mutating func unwrap<T>(_ block: (String) -> T?) throws(Error) -> T {
            guard let value = try self.checked(block) else {
                throw Error.decodingError(
                    "Expected \(T.self) at \(self.currentIndex), got nil",
                    self.codingPath
                )
            }
            return value
        }

        mutating func decodeNil() throws(Error) -> Bool {
            return try self.unwrap { $0.isEmpty }
        }

        mutating func decode(_ type: Bool.Type) throws(Error) -> Bool {
            return try self.unwrap(self.decoder.boolDecodingStrategy.decode)
        }

        mutating func decode(_ type: Int.Type) throws(Error) -> Int {
            return try self.unwrap(Int.init)
        }

        mutating func decode(_ type: Int8.Type) throws(Error) -> Int8 {
            return try self.unwrap(Int8.init)
        }

        mutating func decode(_ type: Int16.Type) throws(Error) -> Int16 {
            return try self.unwrap(Int16.init)
        }

        mutating func decode(_ type: Int32.Type) throws(Error) -> Int32 {
            return try self.unwrap(Int32.init)
        }

        mutating func decode(_ type: Int64.Type) throws(Error) -> Int64 {
            return try self.unwrap(Int64.init)
        }

        mutating func decode(_ type: UInt.Type) throws(Error) -> UInt {
            return try self.unwrap(UInt.init)
        }

        mutating func decode(_ type: UInt8.Type) throws(Error) -> UInt8 {
            return try self.unwrap(UInt8.init)
        }

        mutating func decode(_ type: UInt16.Type) throws(Error) -> UInt16 {
            return try self.unwrap(UInt16.init)
        }

        mutating func decode(_ type: UInt32.Type) throws(Error) -> UInt32 {
            return try self.unwrap(UInt32.init)
        }

        mutating func decode(_ type: UInt64.Type) throws(Error) -> UInt64 {
            return try self.unwrap(UInt64.init)
        }

        mutating func decode(_ type: Float.Type) throws(Error) -> Float {
            return try self.unwrap(Float.init)
        }

        mutating func decode(_ type: Double.Type) throws(Error) -> Double {
            return try self.unwrap(Double.init)
        }

        mutating func decode(_ type: String.Type) throws(Error) -> String {
            return try self.unwrap(id)
        }

        mutating func decode(_ type: Decimal.Type) throws(Error) -> Decimal {
            return try self.unwrap { Decimal(string: $0) ?? Decimal() }
        }

        mutating func decode<T>(_ type: T.Type) throws(Error) -> T where T: Decodable {
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
        ) throws(Error)
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

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        mutating func nestedUnkeyedContainer() throws(Error) -> any UnkeyedDecodingContainer {
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

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        mutating func superDecoder() throws(Error) -> any Swift.Decoder {
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
