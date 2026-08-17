//
//  HTML.Element.Form.Coder.Nested.Data.Parser.swift
//  swift-rfc-2388
//
//  RFC 2388: Returning Values from Forms: multipart/form-data
//

public import HTML_Form_Coder
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Element.Form.Coder.Nested.Data {
    /// Parses a URL-encoded query string into structured form data.
    ///
    /// This function implements RFC 2388 form data parsing with support for
    /// various array notation conventions.
    ///
    /// - Parameters:
    ///   - query: The URL-encoded query string to parse
    ///   - strategy: The parsing strategy for array notation
    ///   - sort: Whether to sort the key-value pairs before parsing
    /// - Returns: A HTML.Element.Form.Coder.Nested.Data structure representing the parsed data
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Simple values
    /// let data = HTML.Element.Form.Coder.Nested.Data.parse("name=John&age=30")
    /// // Result: .dictionary(["name": .value("John"), "age": .value("30")])
    ///
    /// // Arrays with brackets
    /// let tags = HTML.Element.Form.Coder.Nested.Data.parse("tags[]=swift&tags[]=vapor", strategy: .brackets)
    /// // Result: .dictionary(["tags": .array([.value("swift"), .value("vapor")])])
    ///
    /// // Nested objects
    /// let user = HTML.Element.Form.Coder.Nested.Data.parse("user[name]=John&user[email]=john@example.com")
    /// // Result: .dictionary(["user": .dictionary(["name": .value("John"), "email": .value("john@example.com")])])
    /// ```
    public static func parse(
        _ query: String,
        strategy: HTML.Element.Form.Coder.Strategy.Nesting = .brackets,
        sort: Bool = false
    ) -> HTML.Element.Form.Coder.Nested.Data {
        switch strategy {
        case .brackets, .bracketsWithIndices:
            let isArray: (String) -> Bool = { segment in
                // Empty string means brackets notation: key[]
                // Non-empty string that's a number means indexed notation: key[0]
                segment.isEmpty || Int(segment) != nil
            }
            return parseBracketNotation(query, isArray: isArray, sort: sort)

        case .accumulateValues:
            return parseAccumulateValues(query, sort: sort)
        }
    }

    /// Parses form data using bracket notation (e.g., `key[]` or `key[0]`).
    ///
    /// Handles nested structures and both empty brackets and indexed brackets.
    ///
    /// - Parameters:
    ///   - query: The URL-encoded query string
    ///   - isArray: Function to determine if a path segment represents an array
    ///   - sort: Whether to sort key-value pairs before parsing
    /// - Returns: Parsed HTML.Element.Form.Coder.Nested.Data structure
    private static func parseBracketNotation(
        _ query: String,
        isArray: @escaping (String) -> Bool,
        sort: Bool
    ) -> HTML.Element.Form.Coder.Nested.Data {
        var result = HTML.Element.Form.Coder.Nested.Data.dictionary([:])

        for (name, value) in extractPairs(from: query, sort: sort) {
            let path = extractPath(from: name)
            insert(value: value ?? "", at: path, into: &result, isArray: isArray)
        }

        return result
    }

    /// Parses form data by accumulating repeated keys into arrays.
    ///
    /// When the same key appears multiple times, all values are collected
    /// into an array.
    ///
    /// - Parameters:
    ///   - query: The URL-encoded query string
    ///   - sort: Whether to sort key-value pairs before parsing
    /// - Returns: Parsed HTML.Element.Form.Coder.Nested.Data structure
    private static func parseAccumulateValues(
        _ query: String,
        sort: Bool
    ) -> HTML.Element.Form.Coder.Nested.Data {
        var params: [String: HTML.Element.Form.Coder.Nested.Data] = [:]

        for (name, value) in extractPairs(from: query, sort: sort) {
            let valueStr = value ?? ""

            if let existing = params[name] {
                // Key already exists - accumulate into array
                if case .array(var values) = existing {
                    values.append(.value(valueStr))
                    params[name] = .array(values)
                } else {
                    // Convert single value to array
                    params[name] = .array([existing, .value(valueStr)])
                }
            } else {
                // First occurrence of this key
                params[name] = .value(valueStr)
            }
        }

        return .dictionary(params)
    }

    /// Extracts key-value pairs from a URL-encoded query string.
    ///
    /// Uses WHATWG URL encoding specification for decoding, which treats
    /// `+` as space and handles percent-encoding.
    ///
    /// - Parameters:
    ///   - query: The URL-encoded query string
    ///   - sort: Whether to sort pairs by key name
    /// - Returns: Array of decoded key-value pairs
    public static func extractPairs(
        from query: String,
        sort: Bool = false
    ) -> [(String, String?)] {
        let bytes = Array(query.utf8)
        var pairs: [(String, String?)] = []
        var pairStart = 0

        func addPair(_ lo: Int, _ hi: Int) {
            // Empty segments produce no pair, matching the omitting-empty
            // semantics of the former `query.split(separator: "&")`. This
            // covers leading, trailing, and doubled `&` as well as an empty
            // query — an empty segment must not be emitted as `("", nil)`.
            guard lo < hi else { return }

            // Find first '=' within [lo, hi)
            var eqIdx: Int? = nil
            for j in lo..<hi where bytes[j] == 0x3D {
                eqIdx = j
                break
            }

            if let eq = eqIdx {
                let rawName = String(decoding: bytes[lo..<eq], as: UTF8.self)
                let rawValue = String(decoding: bytes[(eq &+ 1)..<hi], as: UTF8.self)
                guard
                    let name = WHATWG_Form_URL_Encoded.PercentEncoding.decodeOrNil(
                        rawName,
                        space: .plus
                    )
                else { return }
                let value = WHATWG_Form_URL_Encoded.PercentEncoding.decodeOrNil(
                    rawValue,
                    space: .plus
                )
                pairs.append((name, value))
            } else {
                let rawName = String(decoding: bytes[lo..<hi], as: UTF8.self)
                guard
                    let name = WHATWG_Form_URL_Encoded.PercentEncoding.decodeOrNil(
                        rawName,
                        space: .plus
                    )
                else { return }
                pairs.append((name, nil))
            }
        }

        for idx in 0..<bytes.count {
            if bytes[idx] == 0x26 {  // '&'
                addPair(pairStart, idx)
                pairStart = idx &+ 1
            }
        }
        if pairStart <= bytes.count {
            addPair(pairStart, bytes.count)
        }

        return sort ? pairs.sorted { $0.0 < $1.0 } : pairs
    }

    /// Extracts a path from a key name with bracket notation.
    ///
    /// Converts bracket notation like `user[address][city]` into path components
    /// `["user", "address", "city"]`.
    ///
    /// - Parameter name: The form field name with optional bracket notation
    /// - Returns: Array of path components
    private static func extractPath(from name: String) -> [String] {
        let result = name.reduce(into: (path: [] as [String], current: "")) { result, char in
            switch char {
            case "[":
                if result.path.isEmpty {
                    result.path.append(result.current)
                    result.current.removeAll()
                }

            case "]":
                result.path.append(result.current)
                result.current.removeAll()

            default:
                result.current.append(char)
            }
        }

        return result.current.isEmpty ? result.path : result.path + [result.current]
    }

    /// Inserts a value at a given path into a HTML.Element.Form.Coder.Nested.Data structure.
    ///
    /// Handles nested dictionaries and arrays, creating intermediate structures
    /// as needed.
    ///
    /// - Parameters:
    ///   - value: The string value to insert
    ///   - path: Array of path components indicating where to insert
    ///   - formData: The HTML.Element.Form.Coder.Nested.Data structure to modify (in/out parameter)
    ///   - isArray: Function to determine if a path segment represents an array
    private static func insert(
        value: String,
        at path: [String],
        into formData: inout HTML.Element.Form.Coder.Nested.Data,
        isArray: @escaping (String) -> Bool
    ) {
        guard !path.isEmpty else {
            formData = .value(value)
            return
        }

        switch formData {
        case .dictionary(var params):
            let key = path[0]

            if path.count == 1 {
                // Leaf value
                params[key] = .value(value)
            } else if path.count == 2, isArray(path[1]) {
                // Direct array: key[]
                var values = params[key]?.arrayValue ?? []
                values.append(.value(value))
                params[key] = .array(values)
            } else if isArray(path[1]) {
                // Array handling
                if path[1].isEmpty {
                    // Empty brackets - accumulate values
                    var values = params[key]?.arrayValue ?? []

                    if path.count > 2 {
                        // Create nested structure
                        var newElement = HTML.Element.Form.Coder.Nested.Data.dictionary([:])
                        insert(
                            value: value,
                            at: Array(path[2...]),
                            into: &newElement,
                            isArray: isArray
                        )
                        values.append(newElement)
                    } else {
                        values.append(.value(value))
                    }

                    params[key] = .array(values)
                } else {
                    // Indexed arrays: key[0]
                    let index = Int(path[1]) ?? 0
                    var values = params[key]?.arrayValue ?? []

                    // Expand array if needed
                    while values.count <= index {
                        values.append(.dictionary([:]))
                    }

                    // Recurse into the specific index
                    if path.count > 2 {
                        insert(
                            value: value,
                            at: Array(path[2...]),
                            into: &values[index],
                            isArray: isArray
                        )
                    } else {
                        values[index] = .value(value)
                    }

                    params[key] = .array(values)
                }
            } else {
                // Nested object
                var nested = params[key] ?? .dictionary([:])
                insert(value: value, at: Array(path[1...]), into: &nested, isArray: isArray)
                params[key] = nested
            }

            formData = .dictionary(params)

        case .array(var values):
            if path.count == 1 {
                values.append(.value(value))
            } else if isArray(path[1]) {
                let index = Int(path[1]) ?? 0

                // Expand array if needed
                while values.count <= index {
                    values.append(.dictionary([:]))
                }

                // Recursively insert
                insert(value: value, at: Array(path[2...]), into: &values[index], isArray: isArray)
            } else {
                var nested = HTML.Element.Form.Coder.Nested.Data.dictionary([:])
                insert(value: value, at: Array(path[1...]), into: &nested, isArray: isArray)
                values.append(nested)
            }

            formData = .array(values)

        case .value:
            // Cannot insert into a value - this shouldn't happen in valid form data
            break
        }
    }
}
