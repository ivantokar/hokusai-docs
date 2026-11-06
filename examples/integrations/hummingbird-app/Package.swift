// swift-tools-version: 6.0
import PackageDescription

// Compiles the Hummingbird code shown in the documentation (it is built in CI, not run).
let package = Package(
    name: "hummingbird-integration",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.0.0"),
        .package(url: "https://github.com/ivantokar/hokusai-hummingbird.git", exact: "2.1.0"),
    ],
    targets: [
        .executableTarget(name: "App", dependencies: [
            .product(name: "Hummingbird", package: "hummingbird"),
            .product(name: "HokusaiHummingbird", package: "hokusai-hummingbird"),
        ]),
    ]
)
