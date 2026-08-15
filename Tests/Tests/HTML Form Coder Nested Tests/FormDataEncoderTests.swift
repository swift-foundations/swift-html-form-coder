import HTML_Standard
import Testing

@testable import HTML_Form_Coder_Nested

//
//  FormDataEncoderTests.swift
//  swift-rfc-2388
//
//  RFC 2388: Returning Values from Forms: multipart/form-data
//

@Suite
struct `HTML.Form.Coder.Nested.Data Encoder Tests` {

    @Test
    func `Encode simple values`() {
        let data = HTML.Form.Coder.Nested.Data.dictionary([
            "name": .value("John"),
            "age": .value("30"),
        ])

        let encoded = data.encode(percentEncode: false)

        // Dictionary order is sorted by key
        #expect(encoded.contains("age=30"))
        #expect(encoded.contains("name=John"))
    }

    @Test
    func `Encode arrays with brackets strategy`() {
        let data = HTML.Form.Coder.Nested.Data.dictionary([
            "tags": .array([.value("swift"), .value("vapor")])
        ])

        let encoded = data.encode(strategy: .brackets, percentEncode: false)

        #expect(encoded == "tags[]=swift&tags[]=vapor")
    }

    @Test
    func `Encode arrays with indices`() {
        let data = HTML.Form.Coder.Nested.Data.dictionary([
            "items": .array([.value("first"), .value("second")])
        ])

        let encoded = data.encode(strategy: .bracketsWithIndices, percentEncode: false)

        #expect(encoded == "items[0]=first&items[1]=second")
    }

    @Test
    func `Encode with accumulate values strategy`() {
        let data = HTML.Form.Coder.Nested.Data.dictionary([
            "color": .array([.value("red"), .value("blue")])
        ])

        let encoded = data.encode(strategy: .accumulateValues, percentEncode: false)

        #expect(encoded == "color=red&color=blue")
    }

    @Test
    func `Encode nested objects`() {
        let data = HTML.Form.Coder.Nested.Data.dictionary([
            "user": .dictionary([
                "name": .value("John"),
                "email": .value("john@example.com"),
            ])
        ])

        let encoded = data.encode(percentEncode: false)

        // Dictionary order is sorted by key
        #expect(encoded == "user[email]=john@example.com&user[name]=John")
    }

    @Test
    func `Round-trip parsing and encoding`() {
        let original = "name=John&tags[]=swift&tags[]=vapor"
        let parsed = HTML.Form.Coder.Nested.Data.parse(original, strategy: .brackets)
        let encoded = parsed.encode(strategy: .brackets, percentEncode: false)

        // Parse again to compare structure
        let reparsed = HTML.Form.Coder.Nested.Data.parse(encoded, strategy: .brackets)

        #expect(parsed == reparsed)
    }
}
