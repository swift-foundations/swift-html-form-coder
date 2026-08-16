import Foundation

extension Corpus {
    static let expected: [String: Foundation.Data] = [
        "KNOWN-NON-ROUNDTRIP": decode("bm9uZQo="),
        "multipart-body": decode(
            "LS0tLS0tQ29kZXJQYXJpdHlCb3VuZGFyeTAxMjM0NTY3ODkNCkNvbnRlbnQtRGlzcG9zaXRpb246IGZvcm0tZGF0YTsgbmFtZT0idXNlcm5hbWUiDQpDb250ZW50LVR5cGU6IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRGLTgNCg0KYWxpY2UNCi0tLS0tLUNvZGVyUGFyaXR5Qm91bmRhcnkwMTIzNDU2Nzg5DQpDb250ZW50LURpc3Bvc2l0aW9uOiBmb3JtLWRhdGE7IG5hbWU9ImJpbyINCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD1VVEYtOA0KDQpoZWxsbyB3b3JsZApzZWNvbmQgbGluZSDinJMNCi0tLS0tLUNvZGVyUGFyaXR5Qm91bmRhcnkwMTIzNDU2Nzg5DQpDb250ZW50LURpc3Bvc2l0aW9uOiBmb3JtLWRhdGE7IG5hbWU9InRhZyINCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD1VVEYtOA0KDQpzd2lmdA0KLS0tLS0tQ29kZXJQYXJpdHlCb3VuZGFyeTAxMjM0NTY3ODkNCkNvbnRlbnQtRGlzcG9zaXRpb246IGZvcm0tZGF0YTsgbmFtZT0idGFnIg0KQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVURi04DQoNCnNlcnZlcg0KLS0tLS0tQ29kZXJQYXJpdHlCb3VuZGFyeTAxMjM0NTY3ODkNCkNvbnRlbnQtRGlzcG9zaXRpb246IGZvcm0tZGF0YTsgZmlsZW5hbWU9Im5vdGVzLnR4dCI7IG5hbWU9Im5vdGVzIg0KQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluDQoNCmZpeGVkIGZpbGUgYnl0ZXMgMDEyMwoNCi0tLS0tLUNvZGVyUGFyaXR5Qm91bmRhcnkwMTIzNDU2Nzg5LS0NCg=="
        ),
        "multipart-contentType": decode(
            "bXVsdGlwYXJ0L2Zvcm0tZGF0YTsgYm91bmRhcnk9LS0tLUNvZGVyUGFyaXR5Qm91bmRhcnkwMTIzNDU2Nzg5Cg=="
        ),
        "multipart-roundtrip": decode("cm91bmR0cmlwOiBlcXVhbAo="),
    ]

    private static func decode(_ value: String) -> Foundation.Data {
        guard let data = Foundation.Data(base64Encoded: value) else {
            preconditionFailure("Invalid canonical corpus encoding")
        }
        return data
    }
}
