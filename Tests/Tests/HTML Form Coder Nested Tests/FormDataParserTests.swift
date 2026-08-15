import HTML_Standard
import Testing

@testable import HTML_Form_Coder_Nested

//
//  FormDataParserTests.swift
//  swift-rfc-2388
//
//  RFC 2388: Returning Values from Forms: multipart/form-data
//

@Suite
struct `HTML.Form.Coder.Nested.Data Parser Tests` {

    @Test
    func `Parse simple key-value pairs`() {
        let result = HTML.Form.Coder.Nested.Data.parse("name=John&age=30")

        guard case .dictionary(let dict) = result else {
            Issue.record("Expected dictionary")
            return
        }

        #expect(dict["name"]?.stringValue == "John")
        #expect(dict["age"]?.stringValue == "30")
    }

    @Test
    func `Parse arrays with brackets strategy`() {
        let result = HTML.Form.Coder.Nested.Data.parse(
            "tags[]=swift&tags[]=vapor",
            strategy: .brackets
        )

        guard case .dictionary(let dict) = result,
            case .array(let tags) = dict["tags"]
        else {
            Issue.record("Expected dictionary with array")
            return
        }

        #expect(tags.count == 2)
        #expect(tags[0].stringValue == "swift")
        #expect(tags[1].stringValue == "vapor")
    }

    @Test
    func `Parse arrays with indices`() {
        let result = HTML.Form.Coder.Nested.Data.parse(
            "items[0]=first&items[1]=second",
            strategy: .bracketsWithIndices
        )

        guard case .dictionary(let dict) = result,
            case .array(let items) = dict["items"]
        else {
            Issue.record("Expected dictionary with array")
            return
        }

        #expect(items.count == 2)
        #expect(items[0].stringValue == "first")
        #expect(items[1].stringValue == "second")
    }

    @Test
    func `Parse with accumulate values strategy`() {
        let result = HTML.Form.Coder.Nested.Data.parse(
            "color=red&color=blue",
            strategy: .accumulateValues
        )

        guard case .dictionary(let dict) = result,
            case .array(let colors) = dict["color"]
        else {
            Issue.record("Expected dictionary with array")
            return
        }

        #expect(colors.count == 2)
        #expect(colors[0].stringValue == "red")
        #expect(colors[1].stringValue == "blue")
    }

    @Test
    func `Parse nested objects`() {
        let result = HTML.Form.Coder.Nested.Data.parse(
            "user[name]=John&user[email]=john@example.com"
        )

        guard case .dictionary(let dict) = result,
            case .dictionary(let user) = dict["user"]
        else {
            Issue.record("Expected nested dictionary")
            return
        }

        #expect(user["name"]?.stringValue == "John")
        #expect(user["email"]?.stringValue == "john@example.com")
    }

    @Test
    func `Extract pairs from query string`() {
        let pairs = HTML.Form.Coder.Nested.Data.extractPairs(from: "name=John&age=30")

        #expect(pairs.count == 2)
        #expect(pairs[0].0 == "name")
        #expect(pairs[0].1 == "John")
        #expect(pairs[1].0 == "age")
        #expect(pairs[1].1 == "30")
    }

    @Test
    func `Handle percent-encoded values`() {
        let result = HTML.Form.Coder.Nested.Data.parse("name=John+Doe&message=Hello%20World")

        guard case .dictionary(let dict) = result else {
            Issue.record("Expected dictionary")
            return
        }

        #expect(dict["name"]?.stringValue == "John Doe")
        #expect(dict["message"]?.stringValue == "Hello World")
    }

    // MARK: - Empty-segment regression (commit 4ecf84e)
    //
    // Byte-level scanning must reproduce the omitting-empty semantics of the
    // former `query.split(separator: "&")`: leading, trailing, and doubled `&`
    // and an empty query emit no pair. A spurious `("", nil)` pair maps to an
    // empty path, which `insert` treats as a whole-structure replacement —
    // silently clobbering already-parsed data.

    @Test
    func `Trailing ampersand does not clobber parsed data`() {
        let pairs = HTML.Form.Coder.Nested.Data.extractPairs(from: "name=Test&")
        #expect(pairs.count == 1)
        #expect(pairs[0].0 == "name")
        #expect(pairs[0].1 == "Test")

        #expect(
            HTML.Form.Coder.Nested.Data.parse("name=Test&") == .dictionary(["name": .value("Test")])
        )
    }

    @Test
    func `Leading ampersand emits no spurious pair`() {
        let pairs = HTML.Form.Coder.Nested.Data.extractPairs(from: "&name=Test")
        #expect(pairs.count == 1)
        #expect(pairs[0].0 == "name")
        #expect(pairs[0].1 == "Test")

        #expect(
            HTML.Form.Coder.Nested.Data.parse("&name=Test") == .dictionary(["name": .value("Test")])
        )
    }

    @Test
    func `Doubled ampersand emits no spurious pair`() {
        let pairs = HTML.Form.Coder.Nested.Data.extractPairs(from: "a=1&&b=2")
        #expect(pairs.count == 2)
        #expect(pairs[0].0 == "a")
        #expect(pairs[0].1 == "1")
        #expect(pairs[1].0 == "b")
        #expect(pairs[1].1 == "2")

        #expect(
            HTML.Form.Coder.Nested.Data.parse("a=1&&b=2")
                == .dictionary(["a": .value("1"), "b": .value("2")])
        )
    }

    @Test
    func `Empty query yields no pairs`() {
        #expect(HTML.Form.Coder.Nested.Data.extractPairs(from: "").isEmpty)
        #expect(HTML.Form.Coder.Nested.Data.parse("") == .dictionary([:]))
    }

    @Test
    func `Empty key with a value is preserved`() {
        // A non-empty segment `=x` still yields an empty-key pair, exactly as
        // the old `.split(separator: "=", omittingEmptySubsequences: false)`
        // did. The empty key maps to an empty path, so `parse` reduces to
        // `.value("x")` — long-standing pre-4ecf84e behavior, left unchanged.
        let pairs = HTML.Form.Coder.Nested.Data.extractPairs(from: "=x")
        #expect(pairs.count == 1)
        #expect(pairs[0].0.isEmpty)
        #expect(pairs[0].1 == "x")

        #expect(HTML.Form.Coder.Nested.Data.parse("=x") == .value("x"))
    }
}
