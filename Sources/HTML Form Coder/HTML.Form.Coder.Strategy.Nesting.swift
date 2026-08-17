public import HTML_Standard

extension HTML.Form.Coder.Strategy {
    /// Bracket/repetition conventions layered above the HTML entry list.
    ///
    /// These conventions are not part of RFC 2388 or the WHATWG wire
    /// algorithm. They are application conventions and therefore live in the
    /// L3 coder rather than under an RFC namespace.
    public enum Nesting: Sendable, Equatable {
        case brackets
        case bracketsWithIndices
        case accumulateValues
    }
}
