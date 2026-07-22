import Foundation
public import HTML_Standard
public import HTML_Form_Coder
public import HTML_Form_Coder_Multipart

extension HTML.Form.Coder.Multipart {
    struct Single: SingleValueEncodingContainer {
        let encoder: HTML.Form.Coder.Multipart.Field.Encoder
        var codingPath: [any CodingKey]

        mutating func encodeNil() throws {
            // Skip
        }

        mutating func encode(_ value: Bool) throws {
            let stringValue = encoder.coder.encode(value)
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: stringValue))
        }

        mutating func encode(_ value: String) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: value))
        }

        mutating func encode(_ value: Double) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode(_ value: Float) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode(_ value: Int) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode(_ value: Int8) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode(_ value: Int16) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode(_ value: Int32) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode(_ value: Int64) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode(_ value: UInt) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode(_ value: UInt8) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode(_ value: UInt16) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode(_ value: UInt32) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode(_ value: UInt64) throws {
            encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: String(value)))
        }

        mutating func encode<T>(_ value: T) throws where T: Encodable {
            // Handle Date
            if let date = value as? Date {
                let stringValue = encoder.coder.encode(date)
                encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: stringValue))
                return
            }

            // Try custom value encoding
            if let customEncoder = encoder.coder.custom,
               let stringValue = customEncoder(value, "") {
                encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: stringValue))
                return
            }

            // Fall back to JSON encoding
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(value)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                encoder.fields.append(HTML.Form.Coder.Multipart.Field(name: "", value: jsonString))
            }
        }
    }
}
