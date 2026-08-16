import Foundation
import HTML_Standard
import Testing

// The checked-in Swift table is the canonical parity corpus. Keeping the
// expected bytes in the test target preserves exact comparisons without a
// second, non-Swift fixture tree beside the tests.

enum Corpus {
    /// Byte-compares one produced value with its canonical entry and records a
    /// diff-style issue on mismatch.
    static func compare(
        _ produced: String,
        named name: String,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let producedData = Data(produced.utf8)
        guard let expectedData = expected[name] else {
            Issue.record(
                "Canonical corpus has no entry named \(name)",
                sourceLocation: sourceLocation
            )
            return
        }
        if expectedData != producedData {
            let expected = String(decoding: expectedData, as: UTF8.self)
            Issue.record(
                """
                Corpus mismatch for \(name)
                --- expected ---
                \(expected)
                --- actual ---
                \(produced)
                """,
                sourceLocation: sourceLocation
            )
        }
    }
}
