# swift-html-form-coder

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

HTML form encoding and decoding for Swift.

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-html-form-coder.git", branch: "main")
]
```

Add the product to a target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "HTML Form Coder", package: "swift-html-form-coder")
    ]
)
```

The remaining capabilities ship as separate products, so a target links only
what it uses:

| Product | Adds |
|---|---|
| `HTML Form Coder Multipart` | `multipart/form-data` encoding and decoding |
| `HTML Form Coder Nested` | nested and collection-valued form keys |
| `HTML Form Coder Codable` | `Encoder` / `Decoder` conformances for form data |

## Error Handling

Each surface declares its own error type, so callers switch over the failures
of the layer they called rather than a shared catch-all:

| Type | Thrown by |
|---|---|
| `HTML.Form.Coder.Error` | the Codable coding surface |
| `HTML.Form.Coder.Encoder.Error` | encoding a value to form data |
| `HTML.Form.Coder.Decoder.Error` | decoding form data to a value |
| `HTML.Form.Coder.Multipart.Error` | `multipart/form-data` parsing |

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
