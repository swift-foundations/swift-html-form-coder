public import Byte_Primitive
public import HTML_Standard
public import HTTP_Body
public import WHATWG_Form_URL_Encoded
public import WHATWG_HTML_FormData

extension HTML.Form.Coder: RFC_9110.Body.Coder.`Protocol` {
    public typealias Input = [Byte]
    public typealias Buffer = [Byte]
    public typealias Output = HTML.Form.Data.Entry.List
    public typealias Failure = Never
    public typealias Body = Never

    @inlinable
    public var body: Never {
        borrowing get {
            return fatalError(
                "leaf codec — parse(_:) and serialize(_:into:) are implemented directly"
            )
        }
    }

    public static var contentType: HTTP.MediaType { .formUrlEncoded }

    @inlinable
    public func parse(_ input: inout [Byte]) -> HTML.Form.Data.Entry.List {
        let source = String(decoding: input.map(\.underlying), as: UTF8.self)
        let entries = WHATWG_Form_URL_Encoded.parse(source).map {
            HTML.Form.Data.Entry(name: $0.0, stringValue: $0.1)
        }
        input = []
        return HTML.Form.Data.Entry.List(entries: entries)
    }

    @inlinable
    public func serialize(
        _ output: HTML.Form.Data.Entry.List,
        into buffer: inout [Byte]
    ) {
        let pairs = output.map { entry -> (String, String) in
            switch entry.value {
            case .string(let value):
                return (entry.name, value)

            case .file(let file):
                return (entry.name, file.name)
            }
        }
        let encoded = WHATWG_Form_URL_Encoded.serialize(pairs)
        buffer.append(contentsOf: encoded.utf8.map(Byte.init))
    }
}
