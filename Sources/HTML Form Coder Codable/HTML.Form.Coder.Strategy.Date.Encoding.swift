public import Foundation
public import HTML_Form_Coder
public import HTML_Standard

extension HTML.Form.Coder.Strategy.Date {
    public struct Encoding: @unchecked Sendable {
        package let encode: @Sendable (Foundation.Date) -> String

        public init(encode: @escaping @Sendable (Foundation.Date) -> String) {
            self.encode = encode
        }

        public static let deferred = Self { _ in "__DEFERRED_TO_DATE__" }
        public static let seconds = Self { String(Int($0.timeIntervalSince1970)) }
        public static let milliseconds = Self { String(Int($0.timeIntervalSince1970 * 1_000)) }
        public static let iso8601 = Self {
            HTML.Form.Coder.Strategy.Date.Format.encode.string(from: $0)
        }

        public static func formatted(_ formatter: DateFormatter) -> Self {
            Self { formatter.string(from: $0) }
        }

        public static func custom(
            _ strategy: @escaping @Sendable (Foundation.Date) -> String
        ) -> Self {
            Self(encode: strategy)
        }
    }
}
