public import HTML_Standard
public import HTML_Form_Coder

extension HTML.Form.Coder.Strategy.Array {
    public struct Decoding: Sendable {
        package let parse: @Sendable (String) -> HTML.Form.Coder.Decoder.Container
        package let handlesSingle: Swift.Bool

        public init(
            parse: @escaping @Sendable (String) -> HTML.Form.Coder.Decoder.Container,
            handlesSingle: Swift.Bool = false
        ) {
            self.parse = parse
            self.handlesSingle = handlesSingle
        }

        public static let accumulateValues = Self(
            parse: HTML.Form.Coder.Decoder.parse(nesting: .accumulateValues),
            handlesSingle: true
        )
        public static let brackets = Self(
            parse: HTML.Form.Coder.Decoder.parse(nesting: .brackets)
        )
        public static let bracketsWithIndices = Self(
            parse: HTML.Form.Coder.Decoder.parse(nesting: .bracketsWithIndices, sort: true)
        )

        public static func custom(
            _ parse: @escaping @Sendable (String) -> HTML.Form.Coder.Decoder.Container
        ) -> Self {
            Self(parse: parse)
        }
    }
}
