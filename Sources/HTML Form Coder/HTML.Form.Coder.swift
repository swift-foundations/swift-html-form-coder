public import HTML_Standard
public import WHATWG_HTML_FormData

extension HTML.Element.Form {
    /// The default HTML form body coder.
    ///
    /// Its wire representation is the HTML specification's default enctype,
    /// `application/x-www-form-urlencoded`. The typed pivot is the ordered
    /// WHATWG form entry list; duplicate names and order are preserved.
    public struct Coder: Sendable {
        @inlinable
        public init() {}
    }
}
