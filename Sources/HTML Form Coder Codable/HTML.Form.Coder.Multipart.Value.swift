public import HTML_Standard
public import HTML_Form_Coder
public import HTML_Form_Coder_Multipart
public import RFC_2046

extension HTML.Form.Coder.Multipart {
    public struct Value<Output: Swift.Codable>: @unchecked Sendable {
        public let boundary: RFC_2046.Boundary?
        public let decoder: HTML.Form.Coder.Decoder
        public let encoder: HTML.Form.Coder.Multipart.Encoder

        public init(
            _ type: Output.Type,
            boundary: RFC_2046.Boundary? = nil,
            decoder: HTML.Form.Coder.Decoder = .init(),
            encoder: HTML.Form.Coder.Multipart.Encoder = .init()
        ) {
            self.boundary = boundary
            self.decoder = decoder
            self.encoder = encoder
        }
    }
}
