public import HTML_Form_Coder
public import HTML_Standard
public import Parser_Primitives

extension HTML.Form.Coder.Nested.Data.Parse.Pairs {
    public struct Pair: Sendable {
        public let key: Input
        public let value: Input

        @inlinable
        public init(key: Input, value: Input) {
            self.key = key
            self.value = value
        }
    }

    public typealias Output = [Pair]
}
