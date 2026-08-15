import Byte_Primitive
import HTML_Form_Coder_Multipart
import HTML_Standard
import HTTP_Body
import RFC_2046
import Testing

extension HTML.Form.Coder.Multipart {
    @Suite
    struct Test {}
}

extension HTML.Form.Coder.Multipart.Test {
    @Test
    func `realized media type carries the pinned boundary`() throws {
        let boundary = try RFC_2046.Boundary("----=_Part_0123456789abcdef0123456789abcdef")
        let coder = HTML.Form.Coder.Multipart(boundary: boundary)
        let expected = HTML.Form.Data.Entry.List(entries: [
            .init(name: "name", stringValue: "Blob")
        ])
        var bytes: [Byte] = []

        let mediaType = try coder.encode(expected, into: &bytes)
        let actual = try coder.decode(&bytes, as: mediaType)

        #expect(mediaType.parameters["boundary"] == boundary.rawValue)
        #expect(actual == expected)
        #expect(bytes.isEmpty)
    }
}
