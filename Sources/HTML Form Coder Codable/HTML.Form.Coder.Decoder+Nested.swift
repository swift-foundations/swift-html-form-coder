import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Element.Form.Coder.Decoder {
    @Sendable
    static func convert(_ data: HTML.Element.Form.Coder.Nested.Data) -> Container {
        switch data {
        case .value(let value):
            .singleValue(value)

        case .array(let values):
            .unkeyed(values.map(Self.convert))

        case .dictionary(let values):
            .keyed(values.mapValues(Self.convert))
        }
    }

    @Sendable
    static func parse(
        nesting: HTML.Element.Form.Coder.Strategy.Nesting,
        sort: Bool = false
    ) -> @Sendable (String) -> Container {
        { query in
            let sanitized =
                query
                .split(separator: "&", omittingEmptySubsequences: true)
                .joined(separator: "&")
            guard !sanitized.isEmpty else {
                return .keyed([:])
            }
            return Self.convert(
                HTML.Element.Form.Coder.Nested.Data.parse(sanitized, strategy: nesting, sort: sort)
            )
        }
    }
}
