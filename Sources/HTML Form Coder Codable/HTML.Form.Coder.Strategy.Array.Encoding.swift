public import HTML_Standard
public import HTML_Form_Coder

extension HTML.Form.Coder.Strategy.Array {
    public enum Encoding: Sendable, Equatable {
        case accumulateValues
        case brackets
        case bracketsWithIndices

        package var nesting: HTML.Form.Coder.Strategy.Nesting {
            switch self {
            case .accumulateValues: .accumulateValues
            case .brackets: .brackets
            case .bracketsWithIndices: .bracketsWithIndices
            }
        }

        package func name(_ name: String, index: Int) -> String {
            switch self {
            case .accumulateValues: name
            case .brackets: "\(name)[]"
            case .bracketsWithIndices: "\(name)[\(index)]"
            }
        }
    }
}
