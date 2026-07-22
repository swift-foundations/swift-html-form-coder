import Foundation
public import HTML_Standard
public import HTML_Form_Coder
public import HTML_Form_Coder_Multipart
import RFC_7578

extension HTML.Form.Coder.Multipart {
    struct Keyed<Key: CodingKey>: KeyedEncodingContainerProtocol {
        let encoder: HTML.Form.Coder.Multipart.Field.Encoder
        var codingPath: [any CodingKey]

        mutating func encodeNil(forKey key: Key) throws {
            // Skip nil values
        }

        mutating func encode(_ value: Bool, forKey key: Key) throws {
            let stringValue = encoder.coder.encode(value)
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: stringValue))
        }

        mutating func encode(_ value: String, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: value))
        }

        mutating func encode(_ value: Int, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode(_ value: Double, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode(_ value: Float, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode(_ value: Int8, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode(_ value: Int16, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode(_ value: Int32, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode(_ value: Int64, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode(_ value: UInt, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode(_ value: UInt8, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode(_ value: UInt16, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode(_ value: UInt32, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode(_ value: UInt64, forKey key: Key) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: String(value)))
        }

        mutating func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
            // 1. Try file extraction first
            if let fileExtractor = encoder.coder.file,
               let file = fileExtractor(value) {
                encoder.files.append(file)
                return
            }

            // 2. Handle Date
            if let date = value as? Date {
                let stringValue = encoder.coder.encode(date)
                encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: stringValue))
                return
            }

            // 3. Handle arrays
            if let array = value as? [Any] {
                try encodeArray(array, forKey: key)
                return
            }

            // 4. Try custom value encoding
            if let customEncoder = encoder.coder.custom,
               let stringValue = customEncoder(value, key.stringValue) {
                encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: stringValue))
                return
            }

            // 5. For other complex types, encode them as nested JSON
            // (This is a simplification - in practice you might want more sophisticated handling)
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(value)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: key.stringValue, value: jsonString))
            }
        }

        private mutating func encodeArray(_ array: [Any], forKey key: Key) throws {
            // Check if this is an array of files
            if let fileExtractor = encoder.coder.file {
                var allFiles = true
                var files: [RFC_7578.Form.Data.File] = []

                for element in array {
                    if let file = fileExtractor(element) {
                        files.append(file)
                    } else {
                        allFiles = false
                        break
                    }
                }

                if allFiles && !files.isEmpty {
                    encoder.files.append(contentsOf: files)
                    return
                }
            }

            // Otherwise, encode as regular array
            for (index, element) in array.enumerated() {
                let fieldName = encoder.coder.array.name(key.stringValue, index: index)
                let stringValue: String
                if let stringElement = element as? String {
                    stringValue = stringElement
                } else if let intElement = element as? Int {
                    stringValue = String(intElement)
                } else if let boolElement = element as? Bool {
                    stringValue = encoder.coder.encode(boolElement)
                } else if let dateElement = element as? Date {
                    stringValue = encoder.coder.encode(dateElement)
                } else {
                    // For complex types, use JSON encoding
                    let jsonEncoder = JSONEncoder()
                    if let encodable = element as? any Encodable,
                       let jsonData = try? jsonEncoder.encode(encodable),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        stringValue = jsonString
                    } else {
                        stringValue = String(describing: element)
                    }
                }

                encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: fieldName, value: stringValue))
            }
        }

        mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
            fatalError("Nested containers not yet implemented for multipart encoding")
        }

        mutating func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
            fatalError("Nested unkeyed containers not yet implemented for multipart encoding")
        }

        mutating func superEncoder() -> any Swift.Encoder {
            encoder
        }

        mutating func superEncoder(forKey key: Key) -> any Swift.Encoder {
            encoder
        }
    }
}
