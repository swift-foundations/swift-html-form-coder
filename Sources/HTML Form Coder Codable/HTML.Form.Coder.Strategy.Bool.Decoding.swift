public import HTML_Standard
public import HTML_Form_Coder

extension HTML.Form.Coder.Strategy.Bool {
    public struct Decoding: Sendable {
        package let decode: @Sendable (String) -> Swift.Bool

        public init(decode: @escaping @Sendable (String) -> Swift.Bool) {
            self.decode = decode
        }

        public static let `true` = Self { ["1", "true"].contains($0.lowercased()) }
        public static let yes = Self { ["1", "true", "yes"].contains($0.lowercased()) }
        public static let numeric = Self { $0 == "1" }

        public static func custom(
            _ strategy: @escaping @Sendable (String) -> Swift.Bool
        ) -> Self {
            Self(decode: strategy)
        }
    }
}
