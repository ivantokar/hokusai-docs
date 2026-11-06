import Foundation
import Hokusai

extension Example {
    static let encodeFormats = Example("encode.formats") {
        // snippet: encode.formats
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 800)

        let encoders: [(String, Hokusai)] = [
            ("converted.jpg", try image.jpeg(quality: 80)),
            ("converted.png", try image.png()),
            ("converted.webp", try image.webp(quality: 80)),
            ("converted-lossless.webp", try image.webp(lossless: true)),
            ("converted.avif", try image.avif(quality: 50)),
            ("converted.tiff", try image.tiff(compression: .deflate)),
            ("converted.gif", try image.gif()),
        ]
        for (name, encoder) in encoders {
            let info = try await encoder.write(to: URL(fileURLWithPath: name))
            print(name, "→", info.format.rawValue, info.byteCount, "bytes")
        }
        // endsnippet
    }

    static let encodeQuality = Example("encode.quality") {
        // snippet: encode.quality
        // A close-up of the lighthouse, where compression artefacts show.
        let detail = try Hokusai(url: URL(fileURLWithPath: "scene.png"))
            .extract(x: 1000, y: 120, width: 380, height: 380)

        for quality in [10, 40, 85] {
            let jpeg = try await detail.jpeg(quality: quality).data()
            let webp = try await detail.webp(quality: quality).data()
            print("quality", quality, "→ jpeg", jpeg.info.byteCount, "webp", webp.info.byteCount)
            try jpeg.data.write(to: URL(fileURLWithPath: "q\(quality).jpg"))
            try webp.data.write(to: URL(fileURLWithPath: "q\(quality).webp"))
        }
        // endsnippet
    }

    static let encodePNG = Example("encode.png") {
        // snippet: encode.png
        let image = try Hokusai(url: URL(fileURLWithPath: "emblem.png"))

        for (name, options) in [
            ("level-1", PNGOptions(compressionLevel: 1)),
            ("level-9", PNGOptions(compressionLevel: 9)),
            ("palette", PNGOptions(palette: PNGPalette(bitDepth: 4))),
        ] {
            let output = try await image.png(options: options).data()
            print(name, "→", output.info.byteCount, "bytes")
            try output.data.write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // endsnippet
    }

    static let encodeAlphaJPEG = Example("encode.alpha-jpeg") {
        // snippet: encode.alpha-jpeg
        let emblem = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 200)

        // JPEG has no alpha. Without flatten, the encoder decides what the transparent corners become.
        try await emblem.jpeg().write(to: URL(fileURLWithPath: "unflattened.jpg"))
        // With flatten, you choose.
        try await emblem.flatten(background: .white).jpeg().write(to: URL(fileURLWithPath: "flattened.jpg"))
        // endsnippet
    }

    static let encodeTerminals = Example("encode.terminals") {
        // snippet: encode.terminals
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 400)

        // data(): bytes and facts about them. An encoder must be selected.
        let output = try await image.webp(quality: 80).data()
        print("data():", output.info.format.rawValue, output.info.width, "×", output.info.height, output.info.byteCount, "bytes")

        // write(to:) infers the encoder from the extension only when none is selected...
        let inferred = try await image.write(to: URL(fileURLWithPath: "inferred.webp"))
        print("inferred:", inferred.format.rawValue)
        // ...an explicit encoder always wins, whatever the extension says.
        let explicit = try await image.png().write(to: URL(fileURLWithPath: "really-png.jpg"))
        print("explicit:", explicit.format.rawValue, "written to a .jpg name")

        // writeChunks(): bounded, backpressured output for streaming.
        var chunks = 0, total = 0
        let streamed = try await image.jpeg().writeChunks(chunkSize: 4096) { chunk in
            chunks += 1; total += chunk.count
        }
        print("writeChunks:", chunks, "chunks,", total, "bytes, info says", streamed.byteCount)

        // outputFormat is known before evaluation, e.g. to set a Content-Type first.
        print("outputFormat:", try image.avif().outputFormat?.rawValue ?? "none", "—", image.outputFormat?.rawValue ?? "none (no encoder)")

        // Mistakes are typed errors.
        do { _ = try await image.data() } catch { print("no encoder →", error) }
        do { _ = try await image.write(to: URL(fileURLWithPath: "out.xyz")) } catch { print("unknown extension →", error) }
        // endsnippet
    }

    static let encodeMetadata = Example("encode.metadata") {
        // snippet: encode.metadata
        // phone.jpg carries EXIF (camera make, software, orientation 6).
        let phone = try Hokusai(url: URL(fileURLWithPath: "phone.jpg"))

        let policies: [(String, MetadataPolicy)] = [
            ("default", .default),
            ("preserveAll", .preserveAll),
            ("removeAll", .removeAll),
            ("keep-exif-only", MetadataPolicy(exif: .preserve, icc: .remove, orientation: .remove)),
        ]
        for (name, policy) in policies {
            let output = try await phone.jpeg().metadataPolicy(policy).data()
            let meta = try await Hokusai(data: output.data).metadata()
            print(name, "→ exif:", meta.exif?.count ?? 0, "bytes, orientation:", meta.orientation.map { "\($0)" } ?? "none",
                  ", size", meta.width, "×", meta.height)
        }
        // endsnippet
    }
}
