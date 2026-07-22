// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-html-form-coder-tests",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    dependencies: [
        .package(path: ".."),
        .package(url: "https://github.com/swift-standards/swift-html-standard.git", branch: "main"),
        .package(url: "https://github.com/swift-whatwg/swift-whatwg-html.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-byte-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-2045.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-2046.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-2183.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-7578.git", branch: "main"),
    ],
    targets: [
        .testTarget(
            name: "HTML Form Coder Tests",
            dependencies: [
                .product(name: "HTML Form Coder", package: "swift-html-form-coder"),
                .product(name: "HTML Standard", package: "swift-html-standard"),
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
            ]
        ),
        .testTarget(
            name: "HTML Form Coder Multipart Tests",
            dependencies: [
                .product(name: "HTML Form Coder Multipart", package: "swift-html-form-coder"),
                .product(name: "HTML Standard", package: "swift-html-standard"),
                .product(name: "WHATWG HTML Forms", package: "swift-whatwg-html"),
                .product(name: "WHATWG HTML FormData", package: "swift-whatwg-html"),
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "RFC 2045", package: "swift-rfc-2045"),
                .product(name: "RFC 2046", package: "swift-rfc-2046"),
                .product(name: "RFC 2183", package: "swift-rfc-2183"),
                .product(name: "RFC 7578", package: "swift-rfc-7578"),
            ],
            exclude: [
                "Multipart Form Coding Parity Tests/__Corpus__",
            ]
        ),
        .testTarget(
            name: "HTML Form Coder Nested Tests",
            dependencies: [
                .product(name: "HTML Form Coder Nested", package: "swift-html-form-coder"),
                .product(name: "HTML Standard", package: "swift-html-standard"),
            ]
        ),
        .testTarget(
            name: "HTML Form Coder Codable Tests",
            dependencies: [
                .product(name: "HTML Form Coder Codable", package: "swift-html-form-coder"),
                .product(name: "HTML Standard", package: "swift-html-standard"),
            ],
            exclude: [
                "URL Form Coding Parity Tests/__Corpus__",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
