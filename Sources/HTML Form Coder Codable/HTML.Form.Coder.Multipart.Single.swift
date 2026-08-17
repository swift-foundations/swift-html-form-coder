import Foundation
public import HTML_Form_Coder
public import HTML_Form_Coder_Multipart
public import HTML_Standard

extension HTML.Element.Form.Coder.Multipart {
    struct Single: SingleValueEncodingContainer {
        let encoder: HTML.Element.Form.Coder.Multipart.Field.Encoder
        // reason: stdlib Codable protocol requirement forces this existential (any CodingKey / Encoder / Decoder / *Container); the conforming type cannot narrow it.
        // swiftlint:disable:next no_any_protocol_existential
        var codingPath: [any CodingKey]

        mutating func encodeNil() {
            // Skip
        }

        mutating func encode(_ value: Bool) {
            let stringValue = encoder.coder.encode(value)
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: stringValue)
            )
        }

        mutating func encode(_ value: String) {
            encoder.fields.append(HTML.Element.Form.Coder.Multipart.Field(name: "", value: value))
        }

        mutating func encode(_ value: Double) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode(_ value: Float) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode(_ value: Int) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode(_ value: Int8) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode(_ value: Int16) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode(_ value: Int32) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode(_ value: Int64) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode(_ value: UInt) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode(_ value: UInt8) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode(_ value: UInt16) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode(_ value: UInt32) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode(_ value: UInt64) {
            encoder.fields.append(
                HTML.Element.Form.Coder.Multipart.Field(name: "", value: String(value))
            )
        }

        mutating func encode<T>(_ value: T) throws(HTML.Element.Form.Coder.Multipart.Error)
        where T: Encodable {
            // Handle Date
            if let date = value as? Date {
                let stringValue = encoder.coder.encode(date)
                encoder.fields.append(
                    HTML.Element.Form.Coder.Multipart.Field(name: "", value: stringValue)
                )
                return
            }

            // Try custom value encoding
            if let customEncoder = encoder.coder.custom,
                let stringValue = customEncoder(value, "")
            {
                encoder.fields.append(
                    HTML.Element.Form.Coder.Multipart.Field(name: "", value: stringValue)
                )
                return
            }

            // Fall back to JSON encoding
            let jsonEncoder = JSONEncoder()
            let jsonData: Foundation.Data
            do {
                jsonData = try jsonEncoder.encode(value)
            } catch {
                throw HTML.Element.Form.Coder.Multipart.Error.media(String(describing: error))
            }
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                encoder.fields.append(
                    HTML.Element.Form.Coder.Multipart.Field(name: "", value: jsonString)
                )
            }
        }
    }
}
