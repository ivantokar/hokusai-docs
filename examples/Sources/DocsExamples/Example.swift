import Foundation
import Hokusai

/// One documented example. The code between `// snippet:` and `// endsnippet` is what the site shows;
/// it is written against plain relative file names, and the runner executes it in a scratch
/// directory that holds copies of the fixtures, so a reader can run the same code next to the
/// downloaded fixtures.
struct Example: Sendable {
    let id: String
    let run: @Sendable () async throws -> Void
    init(_ id: String, run: @escaping @Sendable () async throws -> Void) {
        self.id = id
        self.run = run
    }
}

struct ResultFile: Codable, Equatable {
    var file: String
    var format: String
    var width: Int
    var height: Int
    var bytes: Int
    /// A PNG rendering for formats a browser cannot show (TIFF, HEIF, PDF).
    var preview: String?
}

struct Manifest: Codable {
    var hokusai: String
    var libvips: String
    var examples: [String: [ResultFile]]
}

enum Runner {
    static let webFormats: Set<String> = ["png", "jpeg", "webp", "gif", "avif"]

    static func runAll(_ examples: [Example], fixtures: URL, output: URL, only: String?) async throws {
        let fm = FileManager.default
        let capabilities = try Hokusai.capabilities()
        var manifest = Manifest(hokusai: "2.2.2", libvips: capabilities.libvipsVersion, examples: [:])
        let fixtureNames = try fm.contentsOfDirectory(atPath: fixtures.path)

        for example in examples where only == nil || example.id.hasPrefix(only!) {
            let work = fm.temporaryDirectory.appending(path: "docs-example-\(UUID().uuidString)")
            try fm.createDirectory(at: work, withIntermediateDirectories: true)
            for name in fixtureNames { try fm.copyItem(at: fixtures.appending(path: name), to: work.appending(path: name)) }
            print("• \(example.id)")
            // Each example runs in its own process: process-wide runtime settings (see Hokusai.configure)
            // can then be demonstrated, and one example cannot affect another.
            let child = Process()
            child.executableURL = URL(fileURLWithPath: CommandLine.arguments[0]).resolvingSymlinksInPath()
            child.arguments = ["__child", example.id]
            child.currentDirectoryURL = work
            try child.run()
            child.waitUntilExit()
            guard child.terminationStatus == 0 else {
                throw NSError(domain: "DocsExamples", code: Int(child.terminationStatus),
                              userInfo: [NSLocalizedDescriptionKey: "example \(example.id) failed"])
            }

            let destination = output.appending(path: example.id)
            try? fm.removeItem(at: destination)
            try fm.createDirectory(at: destination, withIntermediateDirectories: true)
            var files: [ResultFile] = []
            for name in try fm.contentsOfDirectory(atPath: work.path).sorted() where !fixtureNames.contains(name) {
                let source = work.appending(path: name)
                try fm.copyItem(at: source, to: destination.appending(path: name))
                files.append(try await describe(source, name: name, destination: destination))
            }
            manifest.examples[example.id] = files
            try? fm.removeItem(at: work)
        }
        if only == nil {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            try encoder.encode(manifest).write(to: output.appending(path: "manifest.json"))
        }
    }

    /// Reads a produced file back with Hokusai itself; formats a browser cannot show get a PNG preview.
    private static func describe(_ source: URL, name: String, destination: URL) async throws -> ResultFile {
        let size = (try? FileManager.default.attributesOfItem(atPath: source.path)[.size] as? Int) ?? 0
        let ext = source.pathExtension.lowercased()
        if ext == "pdf" {
            let preview = name + ".preview.png"
            let page = try Hokusai(url: source, options: InputOptions(page: 0))
            _ = try await page.png().write(to: destination.appending(path: preview))
            let meta = try await page.metadata()
            return ResultFile(file: name, format: "pdf", width: meta.width, height: meta.height, bytes: size, preview: preview)
        }
        let meta = try await Hokusai(url: source).metadata()
        let format = meta.format?.rawValue ?? ext
        var preview: String?
        if !webFormats.contains(format) {
            preview = name + ".preview.png"
            _ = try await Hokusai(url: source).png().write(to: destination.appending(path: preview!))
        }
        return ResultFile(file: name, format: format, width: meta.width, height: meta.height, bytes: size, preview: preview)
    }
}
