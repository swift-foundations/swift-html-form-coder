public import HTML_Standard
public import HTML_Form_Coder
public import RFC_2046

extension HTML.Form.Coder {
    /// The `multipart/form-data` variant of the HTML form body coder.
    public struct Multipart: Sendable {
        /// A pinned boundary, or `nil` to generate one for each encoding.
        public var boundary: RFC_2046.Boundary?

        @inlinable
        public init(boundary: RFC_2046.Boundary? = nil) {
            self.boundary = boundary
        }
    }
}
