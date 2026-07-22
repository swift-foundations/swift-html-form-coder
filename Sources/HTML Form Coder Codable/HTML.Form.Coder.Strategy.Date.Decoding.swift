public import Foundation
public import HTML_Standard
public import HTML_Form_Coder

extension HTML.Form.Coder.Strategy.Date {
    public struct Decoding: @unchecked Sendable {
        package let decode: @Sendable (String) -> Foundation.Date?

        public init(decode: @escaping @Sendable (String) -> Foundation.Date?) {
            self.decode = decode
        }

        public static let deferred = Self { _ in nil }
        public static let seconds = Self { Double($0).map(Foundation.Date.init(timeIntervalSince1970:)) }
        public static let milliseconds = Self {
            Double($0).map { Foundation.Date(timeIntervalSince1970: $0 / 1_000) }
        }
        public static let iso8601 = Self {
            HTML.Form.Coder.Strategy.Date.Format.milliseconds.date(from: $0)
                ?? HTML.Form.Coder.Strategy.Date.Format.seconds.date(from: $0)
        }

        public static func formatted(_ formatter: DateFormatter) -> Self {
            Self { formatter.date(from: $0) }
        }

        public static func custom(
            _ strategy: @escaping @Sendable (String) -> Foundation.Date?
        ) -> Self {
            Self(decode: strategy)
        }
    }
}
