import Foundation
import Hokusai

// swift run DocsExamples [fixtures | run [id-prefix]]
//   fixtures  regenerate examples/fixtures
//   run       run every example (or those whose id starts with the prefix) and write ../public/generated
let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let arguments = Array(CommandLine.arguments.dropFirst())
switch arguments.first ?? "run" {
case "fixtures":
    try await Fixtures.generate(into: root.appending(path: "fixtures"))
    print("fixtures written")
case "__child":
    // Internal: run one example in this process, in the current directory.
    guard let id = arguments.dropFirst().first, let example = allExamples.first(where: { $0.id == id }) else { exit(2) }
    try await example.run()
case "run":
    try await Runner.runAll(
        allExamples,
        fixtures: root.appending(path: "fixtures"),
        output: root.deletingLastPathComponent().appending(path: "public/generated"),
        only: arguments.dropFirst().first
    )
default:
    FileHandle.standardError.write(Data("usage: DocsExamples fixtures | run [id-prefix]\n".utf8))
    exit(2)
}
