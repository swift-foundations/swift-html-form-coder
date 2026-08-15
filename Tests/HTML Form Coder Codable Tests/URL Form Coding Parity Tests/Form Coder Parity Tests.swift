import HTML_Standard
// Batch-0 parity corpus: HTML.Form.Coder.Encoder / HTML.Form.Coder.Decoder wire-shape snapshots.
//
// For every strategy configuration in real-world use (mailgun, mailgun list
// members `.yes`, stripe `.bracketsWithIndices`, identities) plus each
// individual strategy axis with a default-config control, this suite encodes a
// representative fixture value with FIXED timestamps and fixed data bytes,
// snapshots the encoded pair string, decodes it back, and snapshots the
// round-trip equality result. Round-trip failures on the current stack are
// captured as-is in `__Corpus__/KNOWN-NON-ROUNDTRIP.txt`, not fixed.

import Foundation
import Testing
import HTML_Form_Coder_Codable

// MARK: - Fixtures (fixed values only)

private struct Profile: Codable, Equatable {
    let name: String
    let active: Bool
}

/// Nested fixture: nested struct, arrays, bools, optionals, fixed date, fixed data.
private struct NestedFixture: Codable, Equatable {
    let profile: Profile
    let tags: [String]
    let counts: [Int]
    let flags: [Bool]
    let active: Bool
    let score: Double
    let createdAt: Date
    let payload: Foundation.Data
    let nickname: String?
    let motto: String?
}

/// Flat fixture for "flat" strategies (accumulateValues cannot represent nesting).
private struct FlatFixture: Codable, Equatable {
    let name: String
    let count: Int
    let active: Bool
    let score: Double
    let tags: [String]
    let flags: [Bool]
    let createdAt: Date
    let payload: Foundation.Data
    let nickname: String?
    let motto: String?
}

private let fixedDate = Date(timeIntervalSince1970: 1_700_000_000)
private let fixedData = Foundation.Data([0xDE, 0xAD, 0xBE, 0xEF])

private let nestedFixture = NestedFixture(
    profile: Profile(name: "Blob McBlob", active: true),
    tags: ["swift", "server side"],
    counts: [1, 2, 3],
    flags: [true, false],
    active: false,
    score: 4.5,
    createdAt: fixedDate,
    payload: fixedData,
    nickname: nil,
    motto: "carpe diem ✓"
)

private let flatFixture = FlatFixture(
    name: "Blob McBlob",
    count: 42,
    active: true,
    score: 4.5,
    tags: ["swift", "server side"],
    flags: [true, false],
    createdAt: fixedDate,
    payload: fixedData,
    nickname: nil,
    motto: "carpe diem ✓"
)

// MARK: - Real-world configuration replicas

/// Replica of `rfc2822Formatter` in swift-mailgun-types
/// `Sources/Mailgun Types Shared/HTML.Form.Coder.Coder.swift`.
private func rfc2822Formatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}

/// Replica of the fixed-format axis control.
private func yyyyMMddFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}

/// Replica of `HTML.Form.Coder.Encoder.mailgun` (swift-mailgun-types HTML.Form.Coder.Coder.swift:58).
private func mailgunEncoder() -> HTML.Form.Coder.Encoder {
    HTML.Form.Coder.Encoder(
        dataEncodingStrategy: .base64,
        dateEncodingStrategy: .init { rfc2822Formatter().string(from: $0) },
        arrayEncodingStrategy: .brackets
    )
}

/// Replica of `HTML.Form.Coder.Decoder.mailgun` (swift-mailgun-types HTML.Form.Coder.Coder.swift:12).
private func mailgunDecoder() -> HTML.Form.Coder.Decoder {
    HTML.Form.Coder.Decoder(
        dataDecodingStrategy: .base64,
        dateDecodingStrategy: .init { dateString in
            if let date = rfc2822Formatter().date(from: dateString) { return date }
            if let timestamp = Double(dateString) {
                return Date(timeIntervalSince1970: timestamp)
            }
            if let date = ISO8601DateFormatter().date(from: dateString) { return date }
            return nil
        },
        arrayParsingStrategy: .brackets
    )
}

// MARK: - Case table

private struct Case {
    let name: String
    let run: () -> (encoded: String, roundtrip: String)

    init<T: Codable & Equatable>(
        _ name: String,
        _ fixture: T,
        encoder: @autoclosure @escaping () -> HTML.Form.Coder.Encoder,
        decoder: @autoclosure @escaping () -> HTML.Form.Coder.Decoder
    ) {
        self.name = name
        self.run = {
            do {
                let data = try encoder().encode(fixture)
                let encoded = String(decoding: data, as: UTF8.self)
                do {
                    let decoded = try decoder().decode(T.self, from: data)
                    let verdict = decoded == fixture ? "equal" : "mismatch"
                    return (encoded, "roundtrip: \(verdict)")
                } catch {
                    return (encoded, "roundtrip: decode-error: \(error)")
                }
            } catch {
                return ("encode-error: \(error)", "roundtrip: not-run")
            }
        }
    }
}

private func makeCases() -> [Case] { [
    // Default-config controls
    Case(
        "default-flat",
        flatFixture,
        encoder: HTML.Form.Coder.Encoder(),
        decoder: HTML.Form.Coder.Decoder()
    ),
    Case(
        "default-nested",
        nestedFixture,
        encoder: HTML.Form.Coder.Encoder(),
        decoder: HTML.Form.Coder.Decoder()
    ),
    // Bool axis
    Case(
        "bool-yesNo",
        flatFixture,
        encoder: HTML.Form.Coder.Encoder(boolEncodingStrategy: .yes),
        decoder: HTML.Form.Coder.Decoder(boolDecodingStrategy: .yes)
    ),
    // Array axis
    Case(
        "array-brackets",
        nestedFixture,
        encoder: HTML.Form.Coder.Encoder(arrayEncodingStrategy: .brackets),
        decoder: HTML.Form.Coder.Decoder(arrayParsingStrategy: .brackets)
    ),
    Case(
        "array-bracketsWithIndices",
        nestedFixture,
        encoder: HTML.Form.Coder.Encoder(arrayEncodingStrategy: .bracketsWithIndices),
        decoder: HTML.Form.Coder.Decoder(arrayParsingStrategy: .bracketsWithIndices)
    ),
    // Date axis
    Case(
        "date-secondsSince1970",
        flatFixture,
        encoder: HTML.Form.Coder.Encoder(dateEncodingStrategy: .seconds),
        decoder: HTML.Form.Coder.Decoder(dateDecodingStrategy: .seconds)
    ),
    Case(
        "date-millisecondsSince1970",
        flatFixture,
        encoder: HTML.Form.Coder.Encoder(dateEncodingStrategy: .milliseconds),
        decoder: HTML.Form.Coder.Decoder(dateDecodingStrategy: .milliseconds)
    ),
    Case(
        "date-iso8601",
        flatFixture,
        encoder: HTML.Form.Coder.Encoder(dateEncodingStrategy: .iso8601),
        decoder: HTML.Form.Coder.Decoder(dateDecodingStrategy: .iso8601)
    ),
    Case(
        "date-formatted-yyyyMMdd",
        flatFixture,
        encoder: HTML.Form.Coder.Encoder(dateEncodingStrategy: .formatted(yyyyMMddFormatter())),
        decoder: HTML.Form.Coder.Decoder(dateDecodingStrategy: .formatted(yyyyMMddFormatter()))
    ),
    // Foundation.Data axis
    Case(
        "data-base64",
        flatFixture,
        encoder: HTML.Form.Coder.Encoder(dataEncodingStrategy: .base64),
        decoder: HTML.Form.Coder.Decoder(dataDecodingStrategy: .base64)
    ),
    // Real-world configurations
    Case(
        "mailgun",
        nestedFixture,
        encoder: mailgunEncoder(),
        decoder: mailgunDecoder()
    ),
    Case(
        "mailgun-list-members-yesNo",
        nestedFixture,
        encoder: {
            // Replica of Mailgun Lists Types Lists.API.swift:404-418.
            let encoder = mailgunEncoder()
            encoder.boolEncodingStrategy = .yes
            return encoder
        }(),
        decoder: {
            let decoder = mailgunDecoder()
            decoder.boolDecodingStrategy = .yes
            return decoder
        }()
    ),
    Case(
        "mailgun-routes",
        flatFixture,
        encoder: {
            // Replica of HTML.Form.Coder.Encoder.mailgunRoutes (HTML.Form.Coder.Coder.swift:66).
            let encoder = mailgunEncoder()
            encoder.arrayEncodingStrategy = .accumulateValues
            return encoder
        }(),
        decoder: {
            let decoder = mailgunDecoder()
            decoder.arrayParsingStrategy = .accumulateValues
            return decoder
        }()
    ),
    Case(
        "mailgun-events",
        flatFixture,
        encoder: {
            // Replica of HTML.Form.Coder.Encoder.mailgunEvents (HTML.Form.Coder.Coder.swift:74).
            let encoder = HTML.Form.Coder.Encoder(
                dataEncodingStrategy: .base64,
                dateEncodingStrategy: .init { String(Int($0.timeIntervalSince1970)) },
                arrayEncodingStrategy: .accumulateValues
            )
            return encoder
        }(),
        decoder: {
            let decoder = mailgunDecoder()
            decoder.arrayParsingStrategy = .accumulateValues
            return decoder
        }()
    ),
    Case(
        "stripe",
        nestedFixture,
        // Replica of swift-stripe-types Stripe Types Shared/FormCoding.swift:24.
        encoder: HTML.Form.Coder.Encoder(
            dateEncodingStrategy: .seconds,
            arrayEncodingStrategy: .bracketsWithIndices
        ),
        decoder: HTML.Form.Coder.Decoder(
            dateDecodingStrategy: .seconds,
            arrayParsingStrategy: .bracketsWithIndices
        )
    ),
    Case(
        "identities",
        nestedFixture,
        // Replica of swift-identities-types HTML.Form.Coder.Coding.identities.swift:19.
        encoder: HTML.Form.Coder.Encoder(arrayEncodingStrategy: .bracketsWithIndices),
        decoder: HTML.Form.Coder.Decoder(arrayParsingStrategy: .bracketsWithIndices)
    ),
] }

// MARK: - Tests

@Suite("Form Coder Parity")
struct FormCoderParityTests {
    @Test("wire-shape corpus (compare-or-record)")
    func corpus() throws {
        var nonRoundtrip: [String] = []
        for testCase in makeCases() {
            let (encoded, roundtrip) = testCase.run()
            try Corpus.compareOrRecord(
                "encoded: \(encoded)\n\(roundtrip)\n",
                named: testCase.name
            )
            if roundtrip != "roundtrip: equal" {
                nonRoundtrip.append("\(testCase.name): \(roundtrip)")
            }
        }
        let known =
            nonRoundtrip.isEmpty
            ? "none\n"
            : nonRoundtrip.joined(separator: "\n") + "\n"
        try Corpus.compareOrRecord(known, named: "KNOWN-NON-ROUNDTRIP")
    }
}
