import Byte_Primitive
import HTML_Form_Coder
import HTML_Standard
import Testing

extension HTML.Form.Coder {
    @Suite
    struct Test {}
}

extension HTML.Form.Coder.Test {
    @Test
    func `default enctype preserves ordered duplicate entries`() {
        let coder = HTML.Form.Coder()
        let expected = HTML.Form.Data.Entry.List(entries: [
            .init(name: "name", stringValue: "Blob McBlob"),
            .init(name: "tag", stringValue: "swift"),
            .init(name: "tag", stringValue: "server side"),
        ])
        var bytes: [Byte] = []

        coder.serialize(expected, into: &bytes)
        let wire = String(decoding: bytes.map(\.underlying), as: UTF8.self)
        let actual = coder.parse(&bytes)

        #expect(wire == "name=Blob+McBlob&tag=swift&tag=server+side")
        #expect(actual == expected)
        #expect(bytes.isEmpty)
    }
}
