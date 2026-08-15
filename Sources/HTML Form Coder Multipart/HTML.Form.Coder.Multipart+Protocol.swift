public import Byte_Primitive
public import HTML_Form_Coder
public import HTML_Standard
public import HTTP_Body
internal import Media_Type_Standard
public import RFC_2046
public import WHATWG_HTML_FormData

extension HTML.Form.Coder.Multipart: RFC_9110.Body.Coder.`Protocol` {
    public typealias Input = [Byte]
    public typealias Buffer = [Byte]
    public typealias Output = HTML.Form.Data.Entry.List
    public typealias Failure = HTML.Form.Coder.Multipart.Error
    public typealias Body = Never

    @inlinable
    public var body: Never {
        borrowing get {
            return fatalError(
                "leaf codec — parse(_:) and serialize(_:into:) are implemented directly"
            )
        }
    }

    public static var contentType: HTTP.MediaType { .formData }

    public func parse(
        _ input: inout [Byte]
    ) throws(HTML.Form.Coder.Multipart.Error) -> HTML.Form.Data.Entry.List {
        guard let boundary else {
            throw .media("multipart parsing requires a boundary")
        }
        return try parse(&input, boundary: boundary)
    }

    public func decode(
        _ input: inout [Byte],
        as mediaType: HTTP.MediaType
    ) throws(HTML.Form.Coder.Multipart.Error) -> HTML.Form.Data.Entry.List {
        guard let raw = mediaType.parameters["boundary"] else {
            throw .media("multipart/form-data requires a boundary parameter")
        }

        let boundary: RFC_2046.Boundary
        do throws(RFC_2046.Boundary.Error) {
            boundary = try RFC_2046.Boundary(raw)
        } catch {
            throw .boundary(error)
        }
        return try parse(&input, boundary: boundary)
    }

    public func serialize(
        _ output: HTML.Form.Data.Entry.List,
        into buffer: inout [Byte]
    ) throws(HTML.Form.Coder.Multipart.Error) {
        _ = try encode(output, into: &buffer)
    }

    public func encode(
        _ output: HTML.Form.Data.Entry.List,
        into buffer: inout [Byte]
    ) throws(HTML.Form.Coder.Multipart.Error) -> HTTP.MediaType {
        let boundary = boundary ?? RFC_2046.Boundary.random()
        let multipart = try output.multipart(boundary: boundary)
        RFC_2046.Multipart.serialize(multipart, into: &buffer)
        return HTTP.MediaType(multipart.contentType)
    }

    private func parse(
        _ input: inout [Byte],
        boundary: RFC_2046.Boundary
    ) throws(HTML.Form.Coder.Multipart.Error) -> HTML.Form.Data.Entry.List {
        let multipart: RFC_2046.Multipart
        do throws(RFC_2046.Multipart.Error) {
            multipart = try RFC_2046.Multipart.parse(
                from: input,
                parser: RFC_2046.Multipart.Parser(boundary: boundary, subtype: .formData)
            )
        } catch {
            throw .multipart(error)
        }

        let output = try HTML.Form.Data.Entry.List(multipart)
        input = []
        return output
    }
}
