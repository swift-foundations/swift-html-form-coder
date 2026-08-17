import Foundation
public import HTML_Form_Coder
public import HTML_Standard

extension HTML.Element.Form.Coder {
    public struct Value<Output: Swift.Codable>: @unchecked Sendable {
        public let decoder: HTML.Element.Form.Coder.Decoder
        public let encoder: HTML.Element.Form.Coder.Encoder

        public init(
            _ type: Output.Type,
            decoder: HTML.Element.Form.Coder.Decoder = .init(),
            encoder: HTML.Element.Form.Coder.Encoder = .init()
        ) {
            self.decoder = decoder
            self.encoder = encoder
        }
    }
}
