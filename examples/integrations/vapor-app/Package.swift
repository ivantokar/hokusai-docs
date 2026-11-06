// swift-tools-version: 6.0
import PackageDescription

// Compiles the Vapor code shown in the documentation (it is built in CI, not run).
let package = Package(
    name: "vapor-integration",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
        .package(url: "https://github.com/ivantokar/hokusai-vapor.git", exact: "2.1.0"),
    ],
    targets: [
        .executableTarget(name: "App", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "HokusaiVapor", package: "hokusai-vapor"),
        ]),
    ]
)
