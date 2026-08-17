import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Element.Form.Coder.Decoder {
    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        private(set) var decoder: HTML.Element.Form.Coder.Decoder
        let container: [String: Container]

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        var codingPath: [any CodingKey] {
            return self.decoder.codingPath
        }
        var allKeys: [Key] {
            return self.container.keys.compactMap(Key.init(stringValue:))
        }

        private func checked<T>(_ key: Key, _ block: (String) throws(Error) -> T) throws(Error) -> T
        {
            guard let value = self.container[key.stringValue].flatMap(self.decoder.unbox) else {
                throw Error.decodingError(
                    "Expected \(T.self) at \(key), got nil",
                    self.codingPath
                )
            }
            return try block(value)
        }

        private func unwrap<T>(_ key: Key, _ block: (String) -> T?) throws(Error) -> T {
            guard let value = try self.checked(key, block) else {
                throw Error.decodingError(
                    "Expected \(T.self) at \(key), got nil",
                    self.codingPath
                )
            }
            return value
        }

        func contains(_ key: Key) -> Bool {
            return self.container[key.stringValue] != nil
        }

        func decodeNil(forKey key: Key) throws(Error) -> Bool {
            return self.container[key.stringValue].flatMap(self.decoder.unbox).map {
                $0.isEmpty
            } ?? true
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws(Error) -> Bool {
            return try self.unwrap(key, self.decoder.boolDecodingStrategy.decode)
        }

        func decode(_ type: Int.Type, forKey key: Key) throws(Error) -> Int {
            return try self.unwrap(key, Int.init)
        }

        func decode(_ type: Int8.Type, forKey key: Key) throws(Error) -> Int8 {
            return try self.unwrap(key, Int8.init)
        }

        func decode(_ type: Int16.Type, forKey key: Key) throws(Error) -> Int16 {
            return try self.unwrap(key, Int16.init)
        }

        func decode(_ type: Int32.Type, forKey key: Key) throws(Error) -> Int32 {
            return try self.unwrap(key, Int32.init)
        }

        func decode(_ type: Int64.Type, forKey key: Key) throws(Error) -> Int64 {
            return try self.unwrap(key, Int64.init)
        }

        func decode(_ type: UInt.Type, forKey key: Key) throws(Error) -> UInt {
            return try self.unwrap(key, UInt.init)
        }

        func decode(_ type: UInt8.Type, forKey key: Key) throws(Error) -> UInt8 {
            return try self.unwrap(key, UInt8.init)
        }

        func decode(_ type: UInt16.Type, forKey key: Key) throws(Error) -> UInt16 {
            return try self.unwrap(key, UInt16.init)
        }

        func decode(_ type: UInt32.Type, forKey key: Key) throws(Error) -> UInt32 {
            return try self.unwrap(key, UInt32.init)
        }

        func decode(_ type: UInt64.Type, forKey key: Key) throws(Error) -> UInt64 {
            return try self.unwrap(key, UInt64.init)
        }

        func decode(_ type: Float.Type, forKey key: Key) throws(Error) -> Float {
            return try self.unwrap(key, Float.init)
        }

        func decode(_ type: Double.Type, forKey key: Key) throws(Error) -> Double {
            return try self.unwrap(key, Double.init)
        }

        func decode(_ type: String.Type, forKey key: Key) throws(Error) -> String {
            return try self.unwrap(key, id)
        }

        func decode(_ type: Decimal.Type, forKey key: Key) throws(Error) -> Decimal {
            return try self.unwrap(key) { Decimal(string: $0) ?? Decimal() }
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws(Error) -> T where T: Decodable {
            self.decoder.codingPath.append(key)
            defer { self.decoder.codingPath.removeLast() }
            guard let container = self.container[key.stringValue] else {
                throw Error.decodingError(
                    "Expected \(T.self) at \(key), got nil",
                    self.codingPath
                )
            }
            self.decoder.containers.append(container)
            defer { self.decoder.containers.removeLast() }
            return try self.decoder.unbox(container, as: T.self)
        }

        func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws(Error) -> Bool? {
            guard self.contains(key) else { return nil }
            // Check if the value is empty
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(Bool.self, forKey: key)
        }

        func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws(Error) -> Int? {
            guard self.contains(key) else { return nil }
            // Check if the value is empty (for cases like age=)
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(Int.self, forKey: key)
        }

        func decodeIfPresent(_ type: Int8.Type, forKey key: Key) throws(Error) -> Int8? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(Int8.self, forKey: key)
        }

        func decodeIfPresent(_ type: Int16.Type, forKey key: Key) throws(Error) -> Int16? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(Int16.self, forKey: key)
        }

        func decodeIfPresent(_ type: Int32.Type, forKey key: Key) throws(Error) -> Int32? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(Int32.self, forKey: key)
        }

        func decodeIfPresent(_ type: Int64.Type, forKey key: Key) throws(Error) -> Int64? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(Int64.self, forKey: key)
        }

        func decodeIfPresent(_ type: UInt.Type, forKey key: Key) throws(Error) -> UInt? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(UInt.self, forKey: key)
        }

        func decodeIfPresent(_ type: UInt8.Type, forKey key: Key) throws(Error) -> UInt8? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(UInt8.self, forKey: key)
        }

        func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws(Error) -> UInt16? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(UInt16.self, forKey: key)
        }

        func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws(Error) -> UInt32? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(UInt32.self, forKey: key)
        }

        func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws(Error) -> UInt64? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(UInt64.self, forKey: key)
        }

        func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws(Error) -> Float? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(Float.self, forKey: key)
        }

        func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws(Error) -> Double? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(Double.self, forKey: key)
        }

        func decodeIfPresent(_ type: String.Type, forKey key: Key) throws(Error) -> String? {
            guard self.contains(key) else { return nil }
            return try self.decode(String.self, forKey: key)
        }

        func decodeIfPresent(_ type: Decimal.Type, forKey key: Key) throws(Error) -> Decimal? {
            guard self.contains(key) else { return nil }
            if let value = self.container[key.stringValue].flatMap(self.decoder.unbox),
                value.isEmpty
            {
                return nil
            }
            return try self.decode(Decimal.self, forKey: key)
        }

        func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws(Error) -> T?
        where T: Decodable {
            guard self.contains(key) else { return nil }
            return try self.decode(T.self, forKey: key)
        }

        func nestedContainer<NestedKey>(
            keyedBy type: NestedKey.Type,
            forKey key: Key
        ) throws(Error)
            -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
        {

            self.decoder.codingPath.append(key)
            defer { self.decoder.codingPath.removeLast() }
            guard case .keyed(let container)? = self.container[key.stringValue] else {
                throw Error.decodingError("Expected value at \(key), got nil", self.codingPath)
            }
            self.decoder.containers.append(.keyed(container))  // FIXME?
            defer { self.decoder.containers.removeLast() }
            return .init(KeyedContainer<NestedKey>(decoder: self.decoder, container: container))
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        func nestedUnkeyedContainer(forKey key: Key) throws(Error) -> any UnkeyedDecodingContainer {
            self.decoder.codingPath.append(key)
            defer { self.decoder.codingPath.removeLast() }
            guard case .unkeyed(let container)? = self.container[key.stringValue] else {
                throw Error.decodingError("Expected value at \(key), got nil", self.codingPath)
            }
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
        func superDecoder() throws(Error) -> any Swift.Decoder {
            throw Error.decodingError(
                "superDecoder() is not supported in URL form decoding",
                self.codingPath
            )
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        func superDecoder(forKey key: Key) throws(Error) -> any Swift.Decoder {
            self.decoder.codingPath.append(key)
            defer { self.decoder.codingPath.removeLast() }
            guard let container = self.container[key.stringValue] else {
                throw Error.decodingError("Expected value at \(key), got nil", self.codingPath)
            }
            let decoder = HTML.Element.Form.Coder.Decoder()
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
