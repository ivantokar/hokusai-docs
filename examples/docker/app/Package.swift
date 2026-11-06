// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "resizer",
    platforms: [.macOS(.v13)],
    dependencies: [.package(url: "https://github.com/ivantokar/hokusai.git", exact: "2.2.2")],
    targets: [.executableTarget(name: "Resizer", dependencies: [.product(name: "Hokusai", package: "hokusai")])]
)
