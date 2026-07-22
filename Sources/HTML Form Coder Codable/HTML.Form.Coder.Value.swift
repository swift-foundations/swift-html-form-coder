import Foundation
public import HTML_Standard
public import HTML_Form_Coder

extension HTML.Form.Coder {
    public struct Value<Output: Swift.Codable>: @unchecked Sendable {
        public let decoder: HTML.Form.Coder.Decoder
        public let encoder: HTML.Form.Coder.Encoder

        public init(
            _ type: Output.Type,
            decoder: HTML.Form.Coder.Decoder = .init(),
            encoder: HTML.Form.Coder.Encoder = .init()
        ) {
            self.decoder = decoder
            self.encoder = encoder
        }
    }
}
