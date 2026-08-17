public import Foundation
public import HTML_Form_Coder
public import HTML_Form_Coder_Multipart
public import HTML_Standard
public import HTTP_Body
import Media_Type_Standard
import RFC_2045
import RFC_2046
import RFC_2183
import RFC_7578
public import WHATWG_HTML_FormData

extension HTML.Element.Form.Coder.Multipart.Value: RFC_9110.Body.Coder.`Protocol` {
    public typealias Input = [Byte]
    public typealias Buffer = [Byte]
    public typealias Failure = HTML.Element.Form.Coder.Error
    public typealias Body = Never

    public var body: Never {
        borrowing get {
            return fatalError(
                "leaf codec — parse(_:) and serialize(_:into:) are implemented directly"
            )
        }
    }

    public static var contentType: HTTP.MediaType { .formData }

    public func parse(_ input: inout [Byte]) throws(Failure) -> Output {
        guard let boundary else { throw .boundary }
        return try parse(&input, coder: HTML.Element.Form.Coder.Multipart(boundary: boundary))
    }

    public func decode(
        _ input: inout [Byte],
        as mediaType: HTTP.MediaType
    ) throws(Failure) -> Output {
        do {
            var multipart = HTML.Element.Form.Coder.Multipart(boundary: boundary)
            let entries = try multipart.decode(&input, as: mediaType)
            var bytes: [Byte] = []
            HTML.Element.Form.Coder().serialize(entries, into: &bytes)
            return try decoder.decode(
                Output.self,
                from: Foundation.Data(bytes.map(\.underlying))
            )
        } catch {
            throw .coding(String(describing: error))
        }
    }

    public func serialize(
        _ output: Output,
        into buffer: inout [Byte]
    ) throws(Failure) {
        _ = try encode(output, into: &buffer)
    }

    public func encode(
        _ output: Output,
        into buffer: inout [Byte]
    ) throws(Failure) -> HTTP.MediaType {
        do {
            let fields = HTML.Element.Form.Coder.Multipart.Field.Encoder(coder: encoder)
            try output.encode(to: fields)
            guard !fields.fields.isEmpty || !fields.files.isEmpty else {
                throw HTML.Element.Form.Coder.Error.coding(
                    "Cannot encode an HTML multipart form with no fields"
                )
            }

            let entries = HTML.Element.Form.Data.Entry.List(
                entries: fields.fields.map {
                    HTML.Element.Form.Data.Entry(name: $0.name, stringValue: $0.value)
                }
                    + fields.files.map {
                        HTML.Element.Form.Data.Entry(
                            name: $0.fieldName,
                            file: HTML.Element.Form.Data.File(
                                name: $0.filename.value,
                                type: $0.contentType?.headerValue ?? "",
                                body: $0.content
                            )
                        )
                    }
            )
            return try HTML.Element.Form.Coder.Multipart(boundary: boundary).encode(
                entries,
                into: &buffer
            )
        } catch let error as HTML.Element.Form.Coder.Error {
            throw error
        } catch {
            throw .coding(String(describing: error))
        }
    }

    private func parse(
        _ input: inout [Byte],
        coder: HTML.Element.Form.Coder.Multipart
    ) throws(Failure) -> Output {
        do {
            let entries = try coder.parse(&input)
            var bytes: [Byte] = []
            HTML.Element.Form.Coder().serialize(entries, into: &bytes)
            return try decoder.decode(
                Output.self,
                from: Foundation.Data(bytes.map(\.underlying))
            )
        } catch {
            throw .coding(String(describing: error))
        }
    }
}
