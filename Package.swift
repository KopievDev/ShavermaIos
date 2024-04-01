// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Shaverma",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        // 🐬 Fluent driver for MySQL.
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0"),
        .package(url: "https://github.com/dankinsoid/VaporToOpenAPI.git", from: "4.4.1"),
        .package(url: "https://github.com/Kitura/Swift-SMTP", .upToNextMinor(from: "5.1.0")),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "VaporToOpenAPI", package: "VaporToOpenAPI"),
                .product(name: "SwiftSMTP", package: "Swift-SMTP"),
            ]
        ),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),

            // Workaround for https://github.com/apple/swift-package-manager/issues/6940
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "Fluent")
        ])
    ]
)
