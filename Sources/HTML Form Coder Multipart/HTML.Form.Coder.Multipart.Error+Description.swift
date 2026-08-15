public import HTML_Form_Coder
public import HTML_Standard

extension HTML.Form.Coder.Multipart.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .media(let message): return message
        case .boundary(let error): return String(describing: error)
        case .multipart(let error): return String(describing: error)
        case .decoded(let error): return String(describing: error)
        case .file(let error): return String(describing: error)
        case .filename(let error): return String(describing: error)
        }
    }
}
