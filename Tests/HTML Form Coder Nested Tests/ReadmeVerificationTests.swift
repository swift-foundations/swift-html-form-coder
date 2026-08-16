import HTML_Form_Coder
import HTML_Form_Coder_Nested
import HTML_Standard
import Testing

//
//  ReadmeVerificationTests.swift
//  swift-rfc-2388
//
//  Verifies that README code examples actually work
//

@Suite
struct `README Verification` {

    @Test
    func `README Line 31-35: Parse simple key-value pairs`() throws {
        let data = HTML.Form.Coder.Nested.Data.parse("name=John&age=30")

        #expect(data.dictionaryValue?["name"]?.stringValue == "John")
        #expect(data.dictionaryValue?["age"]?.stringValue == "30")
    }

    @Test
    func `README Line 37-39: Parse arrays with bracket notation`() throws {
        let tags = HTML.Form.Coder.Nested.Data.parse(
            "tags[]=swift&tags[]=vapor",
            strategy: .brackets
        )

        let tagsArray = tags.dictionaryValue?["tags"]?.arrayValue
        #expect(tagsArray?.count == 2)
        #expect(tagsArray?[0].stringValue == "swift")
        #expect(tagsArray?[1].stringValue == "vapor")
    }

    @Test
    func `README Line 41-48: Parse nested objects`() throws {
        let user = HTML.Form.Coder.Nested.Data.parse("user[name]=John&user[email]=john@example.com")

        let userDict = user.dictionaryValue?["user"]?.dictionaryValue
        #expect(userDict?["name"]?.stringValue == "John")
        #expect(userDict?["email"]?.stringValue == "john@example.com")
    }

    @Test
    func `README Line 52-62: Encode with brackets strategy`() throws {
        let data = HTML.Form.Coder.Nested.Data.dictionary([
            "name": .value("John"),
            "tags": .array([.value("swift"), .value("vapor")]),
        ])

        let query = data.encode(strategy: .brackets, percentEncode: false)
        #expect(query.contains("name=John"))
        #expect(query.contains("tags[]=swift"))
        #expect(query.contains("tags[]=vapor"))
    }

    @Test
    func `README Line 64-66: Encode with indexed brackets`() throws {
        let data = HTML.Form.Coder.Nested.Data.dictionary([
            "name": .value("John"),
            "tags": .array([.value("swift"), .value("vapor")]),
        ])

        let indexed = data.encode(strategy: .bracketsWithIndices, percentEncode: false)
        #expect(indexed.contains("name=John"))
        #expect(indexed.contains("tags[0]=swift"))
        #expect(indexed.contains("tags[1]=vapor"))
    }

    @Test
    func `README Line 68-70: Encode with accumulate values`() throws {
        let data = HTML.Form.Coder.Nested.Data.dictionary([
            "name": .value("John"),
            "tags": .array([.value("swift"), .value("vapor")]),
        ])

        let accumulated = data.encode(strategy: .accumulateValues, percentEncode: false)
        #expect(accumulated.contains("name=John"))
        #expect(accumulated.contains("tags=swift"))
        #expect(accumulated.contains("tags=vapor"))
    }

    @Test
    func `README Line 76-78: Brackets strategy parsing`() throws {
        let result = HTML.Form.Coder.Nested.Data.parse(
            "tags[]=value1&tags[]=value2",
            strategy: .brackets
        )

        let tags = result.dictionaryValue?["tags"]?.arrayValue
        #expect(tags?.count == 2)
        #expect(tags?[0].stringValue == "value1")
        #expect(tags?[1].stringValue == "value2")
    }

    @Test
    func `README Line 81-83: Brackets with indices parsing`() throws {
        let result = HTML.Form.Coder.Nested.Data.parse(
            "items[0]=first&items[1]=second",
            strategy: .bracketsWithIndices
        )

        let items = result.dictionaryValue?["items"]?.arrayValue
        #expect(items?.count == 2)
        #expect(items?[0].stringValue == "first")
        #expect(items?[1].stringValue == "second")
    }

    @Test
    func `README Line 86-88: Accumulate values parsing`() throws {
        let result = HTML.Form.Coder.Nested.Data.parse(
            "color=red&color=blue",
            strategy: .accumulateValues
        )

        let colors = result.dictionaryValue?["color"]?.arrayValue
        #expect(colors?.count == 2)
        #expect(colors?[0].stringValue == "red")
        #expect(colors?[1].stringValue == "blue")
    }
}
