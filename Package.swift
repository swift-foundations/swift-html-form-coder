// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-html-form-coder",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: "HTML Form Coder", targets: ["HTML Form Coder"]),
        .library(name: "HTML Form Coder Multipart", targets: ["HTML Form Coder Multipart"]),
        .library(name: "HTML Form Coder Nested", targets: ["HTML Form Coder Nested"]),
        .library(name: "HTML Form Coder Codable", targets: ["HTML Form Coder Codable"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-html-standard.git", branch: "main"),
        .package(url: "https://github.com/swift-whatwg/swift-whatwg-html.git", branch: "main"),
        .package(url: "https://github.com/swift-whatwg/swift-whatwg-url.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-http-body.git", branch: "main"),
        .package(url: "https://github.com/swift-standards/swift-media-type-standard.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-byte-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-parser-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-ieee/swift-ieee-754.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-2045.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-2046.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-2183.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-7578.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "HTML Form Coder",
            dependencies: [
                .product(name: "HTML Standard", package: "swift-html-standard"),
                .product(name: "WHATWG HTML FormData", package: "swift-whatwg-html"),
                .product(name: "WHATWG Form URL Encoded", package: "swift-whatwg-url"),
                .product(name: "HTTP Body", package: "swift-http-body"),
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
            ]
        ),
        .target(
            name: "HTML Form Coder Multipart",
            dependencies: [
                "HTML Form Coder",
                .product(name: "HTML Standard", package: "swift-html-standard"),
                .product(name: "WHATWG HTML FormData", package: "swift-whatwg-html"),
                .product(name: "HTTP Body", package: "swift-http-body"),
                .product(name: "Media Type Standard", package: "swift-media-type-standard"),
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "RFC 2045", package: "swift-rfc-2045"),
                .product(name: "RFC 2046", package: "swift-rfc-2046"),
                .product(name: "RFC 2183", package: "swift-rfc-2183"),
                .product(name: "RFC 7578", package: "swift-rfc-7578"),
            ]
        ),
        .target(
            name: "HTML Form Coder Nested",
            dependencies: [
                "HTML Form Coder",
                .product(name: "HTML Standard", package: "swift-html-standard"),
                .product(name: "IEEE 754", package: "swift-ieee-754"),
                .product(name: "WHATWG Form URL Encoded", package: "swift-whatwg-url"),
                .product(name: "Parser Primitives", package: "swift-parser-primitives"),
            ]
        ),
        .target(
            name: "HTML Form Coder Codable",
            dependencies: [
                "HTML Form Coder",
                "HTML Form Coder Multipart",
                "HTML Form Coder Nested",
                .product(name: "HTML Standard", package: "swift-html-standard"),
                .product(name: "WHATWG HTML FormData", package: "swift-whatwg-html"),
                .product(name: "WHATWG Form URL Encoded", package: "swift-whatwg-url"),
                .product(name: "HTTP Body", package: "swift-http-body"),
                .product(name: "Media Type Standard", package: "swift-media-type-standard"),
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "RFC 2045", package: "swift-rfc-2045"),
                .product(name: "RFC 2046", package: "swift-rfc-2046"),
                .product(name: "RFC 2183", package: "swift-rfc-2183"),
                .product(name: "RFC 7578", package: "swift-rfc-7578"),
            ]
        ),
        .testTarget(
            name: "HTML Form Coder Tests",
            dependencies: [
                "HTML Form Coder",
                .product(name: "HTML Standard", package: "swift-html-standard"),
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
            ],
            path: "Tests/HTML Form Coder Tests"
        ),
        .testTarget(
            name: "HTML Form Coder Multipart Tests",
            dependencies: [
                "HTML Form Coder Multipart",
                .product(name: "HTML Standard", package: "swift-html-standard"),
                .product(name: "WHATWG HTML Forms", package: "swift-whatwg-html"),
                .product(name: "WHATWG HTML FormData", package: "swift-whatwg-html"),
                .product(name: "HTTP Body", package: "swift-http-body"),
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "RFC 2045", package: "swift-rfc-2045"),
                .product(name: "RFC 2046", package: "swift-rfc-2046"),
                .product(name: "RFC 2183", package: "swift-rfc-2183"),
                .product(name: "RFC 7578", package: "swift-rfc-7578"),
            ],
            path: "Tests/HTML Form Coder Multipart Tests",
            exclude: [
                "Multipart Form Coding Parity Tests/__Corpus__",
            ]
        ),
        .testTarget(
            name: "HTML Form Coder Nested Tests",
            dependencies: [
                "HTML Form Coder Nested",
                .product(name: "HTML Standard", package: "swift-html-standard"),
            ],
            path: "Tests/HTML Form Coder Nested Tests"
        ),
        .testTarget(
            name: "HTML Form Coder Codable Tests",
            dependencies: [
                "HTML Form Coder Codable",
                .product(name: "HTML Standard", package: "swift-html-standard"),
            ],
            path: "Tests/HTML Form Coder Codable Tests",
            exclude: [
                "URL Form Coding Parity Tests/__Corpus__",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
