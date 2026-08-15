public import HTML_Form_Coder
public import HTML_Standard
public import RFC_2046
public import RFC_2183
public import RFC_7578

extension HTML.Form.Coder.Multipart {
    public enum Error: Swift.Error, Sendable {
        case media(String)
        case boundary(RFC_2046.Boundary.Error)
        case multipart(RFC_2046.Multipart.Error)
        case decoded(RFC_7578.Form.Data.Decoded.Error)
        case file(RFC_7578.Form.Data.Error)
        case filename(RFC_2183.Filename.Error)
    }
}
