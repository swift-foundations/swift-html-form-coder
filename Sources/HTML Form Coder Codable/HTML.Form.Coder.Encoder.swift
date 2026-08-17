public import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder {
    public final class Encoder: Swift.Encoder {
        package var container: Container?
        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        public package(set) var codingPath: [any CodingKey] = []
        public var dataEncodingStrategy: HTML.Form.Coder.Strategy.Data.Encoding
        public var dateEncodingStrategy: HTML.Form.Coder.Strategy.Date.Encoding
        public var arrayEncodingStrategy: HTML.Form.Coder.Strategy.Array.Encoding
        public var boolEncodingStrategy: HTML.Form.Coder.Strategy.Bool.Encoding
        public let userInfo: [CodingUserInfoKey: Any] = [:]

        public init(
            dataEncodingStrategy: HTML.Form.Coder.Strategy.Data.Encoding = .deferred,
            dateEncodingStrategy: HTML.Form.Coder.Strategy.Date.Encoding = .deferred,
            arrayEncodingStrategy: HTML.Form.Coder.Strategy.Array.Encoding =
                .accumulateValues,
            boolEncodingStrategy: HTML.Form.Coder.Strategy.Bool.Encoding = .true
        ) {
            self.dataEncodingStrategy = dataEncodingStrategy
            self.dateEncodingStrategy = dateEncodingStrategy
            self.arrayEncodingStrategy = arrayEncodingStrategy
            self.boolEncodingStrategy = boolEncodingStrategy
        }

        public func encode<T: Encodable>(_ value: T) throws(Error) -> Foundation.Data {
            do {
                try value.encode(to: self)
            } catch {
                throw Error.encodingError(String(describing: error), self.codingPath)
            }
            guard let container = self.container else {
                throw Error.encodingError("No container found", self.codingPath)
            }

            let queryString = Self.serialize(container, strategy: self.arrayEncodingStrategy)
            return Foundation.Data(queryString.utf8)
        }

        package func box<T: Encodable>(_ value: T) throws(Error) -> Container {
            if let date = value as? Date {
                return try self.box(date)
            } else if let data = value as? Foundation.Data {
                return try self.box(data)
            } else if let decimal = value as? Decimal {
                // Handle Decimal specially to avoid its complex internal encoding
                return .singleValue(String(describing: decimal))
            }

            let encoder = HTML.Form.Coder.Encoder(
                dataEncodingStrategy: self.dataEncodingStrategy,
                dateEncodingStrategy: self.dateEncodingStrategy,
                arrayEncodingStrategy: self.arrayEncodingStrategy,
                boolEncodingStrategy: self.boolEncodingStrategy
            )
            do {
                try value.encode(to: encoder)
            } catch {
                throw Error.encodingError(String(describing: error), encoder.codingPath)
            }
            guard let container = encoder.container else {
                throw Error.encodingError("No container found", encoder.codingPath)
            }
            return container
        }

        package func box(_ date: Date) throws(Error) -> Container {
            // Check if using deferredToDate by looking for the special marker
            let result = self.dateEncodingStrategy.encode(date)

            if result == "__DEFERRED_TO_DATE__" {
                let encoder = HTML.Form.Coder.Encoder(
                    dataEncodingStrategy: self.dataEncodingStrategy,
                    dateEncodingStrategy: self.dateEncodingStrategy,
                    arrayEncodingStrategy: self.arrayEncodingStrategy,
                    boolEncodingStrategy: self.boolEncodingStrategy
                )
                do {
                    try date.encode(to: encoder)
                } catch {
                    throw Error.encodingError(String(describing: error), encoder.codingPath)
                }
                guard let container = encoder.container else {
                    throw Error.encodingError("No container found", encoder.codingPath)
                }
                return container
            } else {
                return .singleValue(result)
            }
        }

        package func box(_ data: Foundation.Data) throws(Error) -> Container {
            // Check if using deferredToData by looking for the special marker
            let result = self.dataEncodingStrategy.encode(data)

            if result == "__DEFERRED_TO_DATA__" {
                let encoder = HTML.Form.Coder.Encoder()
                do {
                    try data.encode(to: encoder)
                } catch {
                    throw Error.encodingError(String(describing: error), encoder.codingPath)
                }
                guard let container = encoder.container else {
                    throw Error.encodingError("No container found", encoder.codingPath)
                }
                return container
            } else {
                return .singleValue(result)
            }
        }

        public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key>
        where Key: CodingKey {
            let container = KeyedContainer<Key>(encoder: self)
            self.container = .keyed([:])
            return KeyedEncodingContainer(container)
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        public func unkeyedContainer() -> any UnkeyedEncodingContainer {
            let container = UnkeyedContainer(encoder: self)
            self.container = .unkeyed([])
            return container
        }

        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        public func singleValueContainer() -> any SingleValueEncodingContainer {
            let container = SingleValueContainer(encoder: self)
            self.container = nil
            return container
        }
    }
}
