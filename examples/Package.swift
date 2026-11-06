// swift-tools-version: 6.0
import PackageDescription

// Executable examples for the documentation. Every code block and every result image shown on
// the site is produced here, by the documented release of Hokusai.
let package = Package(
    name: "docs-examples",
    platforms: [.macOS(.v13)],
    dependencies: [
        // The version the documentation targets; keep in step with ../src/versions.json.
        .package(url: "https://github.com/ivantokar/hokusai.git", exact: "2.2.2"),
    ],
    targets: [
        .executableTarget(
            name: "DocsExamples",
            dependencies: [
                .product(name: "Hokusai", package: "hokusai"),
                .product(name: "HokusaiPDF", package: "hokusai"),
            ]
        ),
    ]
)
