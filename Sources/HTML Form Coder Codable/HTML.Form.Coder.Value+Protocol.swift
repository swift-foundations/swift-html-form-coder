public import Foundation
public import HTML_Form_Coder
public import HTML_Standard
public import HTTP_Body
import Media_Type_Standard

extension HTML.Element.Form.Coder.Value: RFC_9110.Body.Coder.`Protocol` {
    public typealias Input = [Byte]
    public typealias Buffer = [Byte]
    public typealias Failure = HTML.Element.Form.Coder.Error
    public typealias Body = Never

    public var body: Never {
        borrowing get {
            return fatalError(
                "leaf codec — parse(_:) and serialize(_:into:) are implemented directly"
            )
        }
    }

    public static var contentType: HTTP.MediaType { .formUrlEncoded }

    public func parse(_ input: inout [Byte]) throws(Failure) -> Output {
        do {
            let value = try decoder.decode(
                Output.self,
                from: Foundation.Data(input.map(\.underlying))
            )
            input = []
            return value
        } catch {
            throw .coding(String(describing: error))
        }
    }

    public func serialize(
        _ output: Output,
        into buffer: inout [Byte]
    ) throws(Failure) {
        do {
            buffer.append(contentsOf: try encoder.encode(output).map(Byte.init))
        } catch {
            throw .coding(String(describing: error))
        }
    }
}
