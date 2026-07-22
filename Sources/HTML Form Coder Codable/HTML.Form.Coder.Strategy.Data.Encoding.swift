public import Foundation
public import HTML_Standard
public import HTML_Form_Coder

extension HTML.Form.Coder.Strategy.Data {
    public struct Encoding: Sendable {
        package let encode: @Sendable (Foundation.Data) -> String

        public init(encode: @escaping @Sendable (Foundation.Data) -> String) {
            self.encode = encode
        }

        public static let deferred = Self { _ in "__DEFERRED_TO_DATA__" }
        public static let base64 = Self { $0.base64EncodedString() }

        public static func custom(
            _ strategy: @escaping @Sendable (Foundation.Data) -> String
        ) -> Self {
            Self(encode: strategy)
        }
    }
}
