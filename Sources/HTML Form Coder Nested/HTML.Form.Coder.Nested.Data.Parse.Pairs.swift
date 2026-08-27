public import HTML_Form_Coder
public import HTML_Standard
public import Parser

extension HTML.Form.Coder.Nested.Data.Parse {
    /// Parses raw `key=value&key=value` pairs without percent decoding.
    public struct Pairs<Input: Collection.Slice.`Protocol`>: Sendable
    where Input: Sendable, Input.Element == UInt8 {
        @inlinable
        public init() {}
    }
}
