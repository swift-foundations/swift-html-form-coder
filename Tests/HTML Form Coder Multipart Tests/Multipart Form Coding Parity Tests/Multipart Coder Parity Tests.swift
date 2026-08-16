import Byte_Primitive
import Foundation
import HTML_Form_Coder
import HTML_Form_Coder_Multipart
import HTML_Standard
import HTTP_Body
import RFC_2045
import RFC_2046
import Testing
import WHATWG_HTML_FormData
import WHATWG_HTML_Forms

// Batch-0 parity corpus: FormData/Multipart veneer wire-shape snapshots.
//
// Encodes a representative HTML.Form.Data.Entry.List (text fields, repeated field
// names, and a file part with fixed bytes/filename/contentType) with a PINNED
// boundary (the API accepts `boundary:` injection at
// Sources/MultipartFormCoding/FormData+Multipart.swift:156 and :228;
// `generateFormBoundary()` only fires when the boundary is nil, so no
// normalization is required). Snapshots the full body bytes as UTF-8 and the
// Content-Type value the encoder exposes, then parses the body back and
// snapshots the round-trip equality result.
//
// Note: the multipart Bool.Encoder strategies (.trueFalse/.yesNo/.numeric,
// dossier B2-06) live in swift-url-routing's RFC_2046.Multipart.Encoder, not
// in this package's surface or dependency stack; MultipartFormCoding exposes
// no Bool or array strategy axis. `HTML.Form.Data.Entry.List` represents
// repetition as repeated entry names instead.

@Suite("Multipart Coder Parity")
struct MultipartCoderParityTests {
    @Test("wire-shape corpus")
    func corpus() throws {
        // PINNED boundary: grammar-valid ASCII, well under the 70-char limit.
        let boundary = try RFC_2046.Boundary("----CoderParityBoundary0123456789")

        var formData = HTML.Form.Data.Entry.List()
        formData.append(name: "username", value: "alice")
        formData.append(name: "bio", value: "hello world\nsecond line ✓")
        formData.append(name: "tag", value: "swift")
        formData.append(name: "tag", value: "server")
        formData.append(
            name: "notes",
            file: HTML.Form.Data.File(
                name: "notes.txt",
                type: "text/plain",
                body: Array("fixed file bytes 0123\n".utf8)
            )
        )

        // Encode: full body bytes with the pinned boundary.
        let coder = HTML.Form.Coder.Multipart(boundary: boundary)
        var bodyBytes: [Byte] = []
        let contentType = try coder.encode(formData, into: &bodyBytes)
        let body = String(decoding: bodyBytes.map(\.underlying), as: UTF8.self)
        Corpus.compare(body, named: "multipart-body")

        // Encode: the Content-Type value the encoder exposes.
        #expect(contentType.parameters["boundary"] == boundary.rawValue)
        Corpus.compare(
            contentType.description + "\n",
            named: "multipart-contentType"
        )

        // Decode: parse the body back and compare entry lists.
        var roundtrip: String
        do {
            var encoded = bodyBytes
            let decoded = try coder.decode(&encoded, as: contentType)
            if decoded == formData {
                roundtrip = "roundtrip: equal"
            } else {
                roundtrip = "roundtrip: mismatch\ndecoded: \(decoded)"
            }
        } catch {
            roundtrip = "roundtrip: parse-error: \(error)"
        }
        Corpus.compare(roundtrip + "\n", named: "multipart-roundtrip")

        let known =
            roundtrip == "roundtrip: equal"
            ? "none\n"
            : "multipart-body: \(roundtrip)\n"
        Corpus.compare(known, named: "KNOWN-NON-ROUNDTRIP")
    }
}
