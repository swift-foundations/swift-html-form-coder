import Foundation
public import HTML_Form_Coder
import HTML_Form_Coder_Nested
public import HTML_Standard
import WHATWG_Form_URL_Encoded

extension HTML.Form.Coder.Decoder.UnkeyedContainer.Key: CodingKey {
    public var stringValue: String {
        return String(self.index)
    }

    public init?(stringValue: String) {
        guard let intValue = Int(stringValue) else { return nil }
        self.init(intValue: intValue)
    }

    public var intValue: Int? {
        return .some(self.index)
    }

    public init?(intValue: Int) {
        self.init(index: intValue)
    }
}
