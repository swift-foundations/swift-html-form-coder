package import Foundation
public import HTML_Form_Coder
public import HTML_Standard

extension HTML.Form.Coder.Strategy.Date {
    package enum Format {
        package static let encode: DateFormatter =
            formatter("yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX")
        package static let milliseconds: DateFormatter =
            formatter("yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX")
        package static let seconds: DateFormatter =
            formatter("yyyy-MM-dd'T'HH:mm:ssXXXXX")

        private static func formatter(_ format: String) -> DateFormatter {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(abbreviation: "GMT")
            formatter.dateFormat = format
            return formatter
        }
    }
}
