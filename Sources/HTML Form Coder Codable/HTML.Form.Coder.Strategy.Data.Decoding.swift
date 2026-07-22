public import Foundation
public import HTML_Standard
public import HTML_Form_Coder

extension HTML.Form.Coder.Strategy.Data {
    public struct Decoding: Sendable {
        package let decode: @Sendable (String) -> Foundation.Data?

        public init(decode: @escaping @Sendable (String) -> Foundation.Data?) {
            self.decode = decode
        }

        public static let deferred = Self { _ in nil }
        public static let base64 = Self { Foundation.Data(base64Encoded: $0) }

        public static func custom(
            _ strategy: @escaping @Sendable (String) -> Foundation.Data?
        ) -> Self {
            Self(decode: strategy)
        }
    }
}
