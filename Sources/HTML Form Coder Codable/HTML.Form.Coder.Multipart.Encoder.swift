package import Foundation
public import HTML_Form_Coder
public import HTML_Form_Coder_Multipart
public import HTML_Standard
public import RFC_7578

extension HTML.Element.Form.Coder.Multipart {
    public final class Encoder: @unchecked Sendable {
        public var bool: HTML.Element.Form.Coder.Strategy.Bool.Encoding
        public var date: HTML.Element.Form.Coder.Strategy.Date.Encoding
        public var array: HTML.Element.Form.Coder.Strategy.Array.Encoding
        public var file: (@Sendable (Any) -> RFC_7578.Form.Data.File?)?
        public var custom: (@Sendable (Any, String) -> String?)?

        public init(
            bool: HTML.Element.Form.Coder.Strategy.Bool.Encoding = .true,
            date: HTML.Element.Form.Coder.Strategy.Date.Encoding = .iso8601,
            array: HTML.Element.Form.Coder.Strategy.Array.Encoding = .accumulateValues,
            file: (@Sendable (Any) -> RFC_7578.Form.Data.File?)? = nil,
            custom: (@Sendable (Any, String) -> String?)? = nil
        ) {
            self.bool = bool
            self.date = date
            self.array = array
            self.file = file
            self.custom = custom
        }

        func encode(_ value: Swift.Bool) -> String {
            bool.encode(value)
        }

        func encode(_ value: Foundation.Date) -> String {
            date.encode(value)
        }
    }
}
