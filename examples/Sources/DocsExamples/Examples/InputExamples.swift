import Foundation
import Hokusai

extension Example {
    static let inputOptions = Example("input.options") {
        // snippet: input.options
        func attempt(_ name: String, _ run: () async throws -> String) async {
            do { print(name, "→", try await run()) } catch { print(name, "→ throws", error) }
        }
        let bytes = try Data(contentsOf: URL(fileURLWithPath: "scene.png"))

        // Limits are checked before any pixel work.
        await attempt("maxPixels 1,000,000") {
            let image = try Hokusai(data: bytes, options: .init(limits: .init(maxPixels: 1_000_000)))
            return "\(try await image.png().data().info.width)"
        }
        await attempt("maxBytes 10,000") {
            let image = try Hokusai(data: bytes, options: .init(limits: .init(maxBytes: 10_000)))
            return "\(try await image.png().data().info.width)"
        }
        // A truncated upload: the default failOn (.warning) rejects it, .none decodes what is there.
        let truncated = bytes.prefix(bytes.count / 2)
        await attempt("truncated, default") {
            let image = try Hokusai(data: truncated)
            return "\(try await image.jpeg().data().info.height) rows"
        }
        await attempt("truncated, failOn .none") {
            let image = try Hokusai(data: truncated, options: .init(failOn: .none))
            return "\(try await image.jpeg().data().info.height) rows"
        }
        // Garbage is not an image, whatever the options.
        await attempt("not an image") { "\(try await Hokusai(data: Data("hello".utf8)).png().data().info.width)" }
        // A missing file is an I/O error from the terminal, not from the constructor.
        await attempt("missing file") { "\(try await Hokusai(url: URL(fileURLWithPath: "missing.png")).png().data().info.width)" }
        // endsnippet
    }

    static let inputPages = Example("input.pages") {
        // snippet: input.pages
        // Make a 3-page PDF from three renderings, then load each page as an image.
        let scene = try Hokusai(url: URL(fileURLWithPath: "scene.png"))
        let first = try await scene.resize(width: 600).pdf().write(to: URL(fileURLWithPath: "one.pdf"))
        print("one.pdf pages:", first.pdf?.pageCount ?? 0)

        let meta = try await Hokusai(url: URL(fileURLWithPath: "one.pdf")).metadata()
        print("page count read back:", meta.pages.count, "size:", meta.width, "×", meta.height)

        do {
            _ = try await Hokusai(url: URL(fileURLWithPath: "one.pdf"), options: .init(page: 3)).png().data()
        } catch {
            print("page 3 of 1 →", error)
        }
        do {
            _ = try await Hokusai(url: URL(fileURLWithPath: "scene.png"), options: .init(page: 1)).png().data()
        } catch {
            print("page 1 of a PNG →", error)
        }
        // endsnippet
    }

    static let inputRaw = Example("input.raw") {
        // snippet: input.raw
        // Raw pixels you already hold: here, a 4 × 2 RGBA image drawn by hand.
        var pixels = Data()
        for y in 0..<2 {
            for x in 0..<4 {
                pixels.append(contentsOf: [UInt8(x * 80), UInt8(y * 200), 128, 255])   // R G B A
            }
        }
        let tiny = try Hokusai(raw: pixels, width: 4, height: 2, format: .rgba8)

        // Every transformation works on it; nearest keeps the pixels visible.
        try await tiny.resize(width: 200, kernel: .nearest).png().write(to: URL(fileURLWithPath: "tiny.png"))

        // And pixels come back out as RawImage: the format, size, stride and alpha convention are stated.
        let frame = try await Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 64).raw(.rgb8)
        print("raw out:", frame.width, "×", frame.height, "stride", frame.rowStride, "bytes", frame.byteCount, "format", frame.format)

        // A wrong byte count is rejected before any native work.
        do { _ = try Hokusai(raw: Data(count: 10), width: 4, height: 2, format: .rgba8) } catch { print("bad count →", error) }
        // endsnippet
    }

    static let inputSpool = Example("input.spool") {
        // snippet: input.spool
        // An upload that arrives in 16 KB chunks, as a server would receive it.
        let bytes = try Data(contentsOf: URL(fileURLWithPath: "scene.png"))
        let chunks = stride(from: 0, to: bytes.count, by: 16_384).map { bytes[$0..<min($0 + 16_384, bytes.count)] }

        struct Chunks: AsyncSequence {
            let parts: [Data]
            struct Iterator: AsyncIteratorProtocol {
                var index = 0
                let parts: [Data]
                mutating func next() async -> Data? { defer { index += 1 }; return index < parts.count ? parts[index] : nil }
            }
            func makeAsyncIterator() -> Iterator { Iterator(parts: parts) }
        }

        // Below memoryLimit the upload stays in memory; above it, it moves to a private temporary file.
        let image = try await Hokusai(spooling: Chunks(parts: chunks.map { Data($0) }), memoryLimit: 64 * 1024)
        let output = try await image.resize(width: 400).webp().data()
        print("spooled", chunks.count, "chunks →", output.info.width, "×", output.info.height)

        // maxBytes applies while the body is read, so an oversized upload stops early.
        do {
            _ = try await Hokusai(spooling: Chunks(parts: chunks.map { Data($0) }), options: .init(limits: .init(maxBytes: 50_000)))
        } catch {
            print("over maxBytes →", error)
        }
        // endsnippet
    }
}
