public import HTML_Standard
public import HTML_Form_Coder

extension HTML.Form.Coder.Strategy.Bool {
    public struct Encoding: Sendable {
        package let encode: @Sendable (Swift.Bool) -> String

        public init(encode: @escaping @Sendable (Swift.Bool) -> String) {
            self.encode = encode
        }

        public static let `true` = Self { $0 ? "true" : "false" }
        public static let yes = Self { $0 ? "yes" : "no" }
        public static let numeric = Self { $0 ? "1" : "0" }

        public static func custom(
            _ strategy: @escaping @Sendable (Swift.Bool) -> String
        ) -> Self {
            Self(encode: strategy)
        }
    }
}
