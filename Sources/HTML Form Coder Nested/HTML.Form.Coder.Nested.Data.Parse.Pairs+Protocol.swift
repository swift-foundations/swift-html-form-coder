public import HTML_Form_Coder
public import HTML_Standard
public import Parser_Primitives

extension HTML.Element.Form.Coder.Nested.Data.Parse.Pairs: Parser.`Protocol` {
    public typealias Failure = Never

    @inlinable
    public func parse(_ input: inout Input) -> Output {
        var pairs: [Pair] = []

        while input.startIndex < input.endIndex {
            var keyEnd = input.startIndex
            while keyEnd < input.endIndex
                && input[keyEnd] != 0x3D
                && input[keyEnd] != 0x26
            {
                input.formIndex(after: &keyEnd)
            }

            let key = input[input.startIndex..<keyEnd]
            if keyEnd < input.endIndex && input[keyEnd] == 0x3D {
                input.formIndex(after: &keyEnd)
                let valueStart = keyEnd
                while keyEnd < input.endIndex && input[keyEnd] != 0x26 {
                    input.formIndex(after: &keyEnd)
                }
                pairs.append(Pair(key: key, value: input[valueStart..<keyEnd]))
            } else if key.startIndex < key.endIndex {
                pairs.append(Pair(key: key, value: input[keyEnd..<keyEnd]))
            }

            if keyEnd < input.endIndex && input[keyEnd] == 0x26 {
                input.formIndex(after: &keyEnd)
            }
            input = input[keyEnd...]
        }

        return pairs
    }
}
