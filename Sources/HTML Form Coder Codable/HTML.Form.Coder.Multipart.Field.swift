public import HTML_Standard
public import HTML_Form_Coder
public import HTML_Form_Coder_Multipart

extension HTML.Form.Coder.Multipart {
    struct Field: Sendable {
        let name: String
        let value: String
    }
}
