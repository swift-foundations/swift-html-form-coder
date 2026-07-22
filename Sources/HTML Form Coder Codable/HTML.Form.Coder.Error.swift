public import HTML_Standard
public import HTML_Form_Coder

extension HTML.Form.Coder {
    public enum Error: Swift.Error, Sendable, CustomStringConvertible {
        case coding(String)
        case boundary

        public var description: String {
            switch self {
            case .coding(let description): description
            case .boundary: "multipart/form-data requires a valid boundary"
            }
        }
    }
}
