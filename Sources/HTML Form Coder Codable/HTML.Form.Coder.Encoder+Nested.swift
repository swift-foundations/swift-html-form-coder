import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Encoder {
    static func convert(_ container: Container) -> HTML.Form.Coder.Nested.Data {
        switch container {
        case .singleValue(let value):
            .value(value)

        case .unkeyed(let values):
            .array(values.map(Self.convert))

        case .keyed(let values):
            .dictionary(values.mapValues(Self.convert))
        }
    }

    static func serialize(
        _ container: Container,
        strategy: HTML.Form.Coder.Strategy.Array.Encoding
    ) -> String {
        Self.convert(container).encode(strategy: strategy.nesting, percentEncode: false)
    }
}
