public import Byte_Primitive
public import HTML_Form_Coder
public import HTML_Standard
public import RFC_2045
public import RFC_2046
public import RFC_2183
public import RFC_7578
public import WHATWG_HTML_FormData

extension HTML.Form.Data.Entry.List {
    public init(
        _ multipart: RFC_2046.Multipart
    ) throws(HTML.Form.Coder.Multipart.Error) {
        var entries: [HTML.Form.Data.Entry] = []
        entries.reserveCapacity(multipart.parts.count)

        for part in multipart.parts {
            let decoded: RFC_7578.Form.Data.Decoded
            do throws(RFC_7578.Form.Data.Decoded.Error) {
                decoded = try RFC_7578.Form.Data.Decoded([part])
            } catch {
                throw .decoded(error)
            }

            if let field = decoded.fields.first {
                entries.append(.init(name: field.name, stringValue: field.value))
                continue
            }

            if let file = decoded.files.first {
                entries.append(
                    .init(
                        name: file.fieldName,
                        file: HTML.Form.Data.File(
                            name: file.filename.value,
                            type: file.contentType?.headerValue ?? "",
                            body: file.content
                        )
                    )
                )
                continue
            }

            throw .media("multipart/form-data part produced neither a field nor a file")
        }

        self.init(entries: entries)
    }

    public func multipart(
        boundary: RFC_2046.Boundary
    ) throws(HTML.Form.Coder.Multipart.Error) -> RFC_2046.Multipart {
        var parts: [RFC_2046.BodyPart] = []
        parts.reserveCapacity(count)

        for entry in self {
            switch entry.value {
            case .string(let value):
                parts.append(
                    RFC_2046.BodyPart(
                        headers: RFC_2046.BodyPart.Headers(
                            contentDisposition: .formData(name: entry.name),
                            contentType: .textPlainUTF8
                        ),
                        content: RFC_2046.BodyPart.Content([Byte](value.utf8))
                    )
                )

            case .file(let value):
                let filename: RFC_2183.Filename
                do throws(RFC_2183.Filename.Error) {
                    filename = try RFC_2183.Filename(value.name)
                } catch {
                    throw .filename(error)
                }

                let contentType: RFC_2045.ContentType?
                if value.type.isEmpty {
                    contentType = nil
                } else {
                    do throws(RFC_2045.ContentType.Error) {
                        contentType = try RFC_2045.ContentType(value.type)
                    } catch {
                        contentType = nil
                    }
                }

                let file: RFC_7578.Form.Data.File
                do throws(RFC_7578.Form.Data.Error) {
                    file = try RFC_7578.Form.Data.File(
                        fieldName: entry.name,
                        filename: filename,
                        contentType: contentType,
                        content: value.body
                    )
                } catch {
                    throw .file(error)
                }

                parts.append(
                    RFC_2046.BodyPart(
                        headers: RFC_2046.BodyPart.Headers(
                            contentDisposition: .formData(
                                name: file.fieldName,
                                filename: file.filename
                            ),
                            contentType: file.contentType
                        ),
                        content: RFC_2046.BodyPart.Content(file.content.map(Byte.init))
                    )
                )
            }
        }

        do throws(RFC_2046.Multipart.Error) {
            return try RFC_2046.Multipart(
                subtype: .formData,
                parts: parts,
                boundary: boundary
            )
        } catch {
            throw .multipart(error)
        }
    }
}
