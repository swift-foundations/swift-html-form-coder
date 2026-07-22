public import Foundation
public import HTML_Standard
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder {
    public final class Decoder: Swift.Decoder {
        package var containers: [Container] = []
        package var container: Container {
            return containers.last!
        }
        public package(set) var codingPath: [any CodingKey] = []
        public var dataDecodingStrategy: HTML.Form.Coder.Strategy.Data.Decoding
        public var dateDecodingStrategy: HTML.Form.Coder.Strategy.Date.Decoding
        public var arrayParsingStrategy: HTML.Form.Coder.Strategy.Array.Decoding
        public var boolDecodingStrategy: HTML.Form.Coder.Strategy.Bool.Decoding
        public let userInfo: [CodingUserInfoKey: Any] = [:]

        public init(
            dataDecodingStrategy: HTML.Form.Coder.Strategy.Data.Decoding = .deferred,
            dateDecodingStrategy: HTML.Form.Coder.Strategy.Date.Decoding = .deferred,
            arrayParsingStrategy: HTML.Form.Coder.Strategy.Array.Decoding = .accumulateValues,
            boolDecodingStrategy: HTML.Form.Coder.Strategy.Bool.Decoding = .true
        ) {
            self.dataDecodingStrategy = dataDecodingStrategy
            self.dateDecodingStrategy = dateDecodingStrategy
            self.arrayParsingStrategy = arrayParsingStrategy
            self.boolDecodingStrategy = boolDecodingStrategy
        }

        public func decode<T: Decodable>(
            _ type: T.Type,
            from data: Foundation.Data
        ) throws -> T {
            let query = String(decoding: data, as: UTF8.self)
            let container = self.arrayParsingStrategy.parse(query)
            self.containers.append(container)
            defer { self.containers.removeLast() }
            return try T(from: self)
        }

        package func unbox(_ container: Container) -> String? {
            if self.arrayParsingStrategy.handlesSingle {
                // For accumulateValues strategy, handle both single values and arrays
                // If it's an array, take the last value; if it's a single value, return it
                return container.values?.last?.value ?? container.value
            } else {
                return container.value
            }
        }

        package func unbox(
            _ value: Container,
            as type: Foundation.Data.Type
        ) throws -> Foundation.Data {
            guard let string = unbox(value) else {
                throw Error.decodingError("Expected string data, got \(value)", self.codingPath)
            }

            // Decode the data using the strategy
            guard let data = self.dataDecodingStrategy.decode(string) else {
                // If decode returns nil, it means we should use deferredToData
                return try Foundation.Data(from: self)
            }
            return data
        }

        package func unbox(_ value: Container, as type: Date.Type) throws -> Date {
            guard let string = unbox(value) else {
                throw Error.decodingError("Expected string date, got \(value)", self.codingPath)
            }

            // Decode the date using the strategy
            guard let date = self.dateDecodingStrategy.decode(string) else {
                // If decode returns nil, it means we should use deferredToDate
                return try Date(from: self)
            }
            return date
        }

        package func unbox<T: Decodable>(_ value: Container, as type: T.Type) throws -> T {
            if type == Foundation.Data.self {
                guard let result = try self.unbox(value, as: Foundation.Data.self) as? T else {
                    throw Error.decodingError(
                        "Internal error: expected \(T.self) to be Data",
                        self.codingPath
                    )
                }
                return result
            } else if type == Date.self {
                guard let result = try self.unbox(value, as: Date.self) as? T else {
                    throw Error.decodingError(
                        "Internal error: expected \(T.self) to be Date",
                        self.codingPath
                    )
                }
                return result
            } else if type == Decimal.self {
                guard let result = try self.unbox(value, as: Decimal.self) as? T else {
                    throw Error.decodingError(
                        "Internal error: expected \(T.self) to be Decimal",
                        self.codingPath
                    )
                }
                return result
            } else {
                return try T(from: self)
            }
        }

        package func unbox(_ value: Container, as type: Decimal.Type) throws -> Decimal {
            guard let string = unbox(value) else {
                throw Error.decodingError("Expected string decimal, got \(value)", self.codingPath)
            }

            guard let decimal = Decimal(string: string) else {
                throw Error.decodingError("Invalid decimal string: \(string)", self.codingPath)
            }

            return decimal
        }

        public func container<Key>(
            keyedBy type: Key.Type
        ) throws
            -> KeyedDecodingContainer<Key>
        where Key: CodingKey {

            guard case .keyed(let container) = self.container else {
                throw Error.decodingError(
                    "Expected keyed container, got \(self.container)",
                    self.codingPath
                )
            }
            return .init(KeyedContainer(decoder: self, container: container))
        }

        public func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
            switch self.container {
            case .unkeyed(let container):
                return UnkeyedContainer(
                    decoder: self,
                    container: container,
                    codingPath: self.codingPath
                )
            case .singleValue(let value):
                // For strategies like accumulateValues, treat a single value as an array with one element
                if self.arrayParsingStrategy.handlesSingle {
                    let container = [Container.singleValue(value)]
                    return UnkeyedContainer(
                        decoder: self,
                        container: container,
                        codingPath: self.codingPath
                    )
                } else {
                    throw Error.decodingError(
                        "Expected unkeyed container, got \(self.container)",
                        self.codingPath
                    )
                }
            default:
                throw Error.decodingError(
                    "Expected unkeyed container, got \(self.container)",
                    self.codingPath
                )
            }
        }

        public func singleValueContainer() throws -> any SingleValueDecodingContainer {
            return SingleValueContainer(decoder: self, container: self.container)
        }

    }
}
