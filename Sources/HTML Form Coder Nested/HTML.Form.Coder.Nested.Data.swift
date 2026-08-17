public import HTML_Form_Coder
public import HTML_Standard

extension HTML.Element.Form.Coder.Nested {
    /// A hierarchical projection of flat form names such as `user[name]` and
    /// `tags[]`.
    public indirect enum Data: Sendable, Equatable {
        case value(String)
        case array([Data])
        case dictionary([String: Data])
    }
}

extension HTML.Element.Form.Coder.Nested.Data {
    public var stringValue: String? {
        guard case .value(let value) = self else { return nil }
        return value
    }

    public var arrayValue: [Self]? {
        guard case .array(let value) = self else { return nil }
        return value
    }

    public var dictionaryValue: [String: Self]? {
        guard case .dictionary(let value) = self else { return nil }
        return value
    }
}
