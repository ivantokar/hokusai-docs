import Foundation
import Hokusai

extension Example {
    static let blurSigma = Example("effects.blur") {
        // snippet: effects.blur
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 480)

        for sigma in [1.0, 4.0, 10.0] {
            try await image.blur(sigma: sigma).webp(quality: 85)
                .write(to: URL(fileURLWithPath: "sigma-\(Int(sigma)).webp"))
        }

        // Pixels are weighted by alpha, so a transparent edge does not bleed colour into the blur.
        try await Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 200)
            .blur(sigma: 6).png().write(to: URL(fileURLWithPath: "emblem-blur.png"))
        // endsnippet
    }

    static let sharpenExample = Example("effects.sharpen") {
        // snippet: effects.sharpen
        // Shrinking softens an image; sharpen after resizing, not before.
        let small = try Hokusai(url: URL(fileURLWithPath: "scene.png"))
            .resize(width: 640)
            .extract(x: 380, y: 60, width: 220, height: 220)       // look at the lighthouse close up

        try await small.png().write(to: URL(fileURLWithPath: "none.png"))
        try await small.sharpen().png().write(to: URL(fileURLWithPath: "default.png"))
        try await small.sharpen(sigma: 2).png().write(to: URL(fileURLWithPath: "sigma-2.png"))
        try await small.sharpen(SharpenOptions(sigma: 1.5, flat: 1, jagged: 6)).png()
            .write(to: URL(fileURLWithPath: "custom.png"))
        // endsnippet
    }

    static let toneExample = Example("effects.tone") {
        // snippet: effects.tone
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 360)
        let dull = try image.linear(multiply: 0.45, add: 70)      // a low-contrast starting point (see Filters)

        let variants: [(String, Hokusai)] = [
            ("original", image),
            ("grayscale", image.grayscale()),
            ("tint", try image.tint(Color(red: 0.95, green: 0.55, blue: 0.1))),
            ("dull", dull),
            ("normalize", try dull.normalize()),
            ("clahe", try dull.clahe(width: 48, height: 48, maxSlope: 2)),
            ("gamma", try image.gamma(2.2)),
            ("modulate", try image.modulate(brightness: 1.1, saturation: 0.4, hue: 40)),
            ("negate", image.negate()),
            ("threshold", try image.threshold(110)),
        ]
        for (name, pipeline) in variants {
            try await pipeline.webp(quality: 85).write(to: URL(fileURLWithPath: "\(name).webp"))
        }
        // endsnippet
    }

    static let colorSpaces = Example("effects.convert") {
        // snippet: effects.convert
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 360)

        // grayscale() keeps the RGB layout; convert(to: .grayscale) produces one colour channel.
        let looksGray = try await image.grayscale().png().data()
        let oneChannel = try await image.convert(to: .grayscale).png().data()

        for (name, output) in [("grayscale-rgb", looksGray), ("grayscale-1ch", oneChannel)] {
            let channels = try await Hokusai(data: output.data).metadata().pixel.channels
            print(name, "→", channels, "channel(s),", output.data.count, "bytes")
            try output.data.write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // endsnippet
    }

    static let filtersExample = Example("effects.filters") {
        // snippet: effects.filters
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 360)

        let sharpen = try ConvolutionKernel(width: 3, height: 3, values: [0, -1, 0, -1, 5, -1, 0, -1, 0])
        let emboss = try ConvolutionKernel(width: 3, height: 3, values: [-2, -1, 0, -1, 1, 1, 0, 1, 2], offset: 128)

        let variants: [(String, Hokusai)] = [
            ("median", try image.median(size: 7)),
            ("convolve-sharpen", image.convolve(sharpen)),
            ("convolve-emboss", image.convolve(emboss)),
            ("sepia", image.recombine(.sepia)),
            ("swap-red-blue", image.recombine(.swapRedBlue)),
            ("sobel", try image.edges(.sobel)),
            ("canny", try image.edges(.canny(sigma: 1.4))),
            ("binary", try image.threshold(110)),
            ("mask-dilate", try image.threshold(110).dilate(radius: 3)),
            ("mask-erode", try image.threshold(110).erode(radius: 3)),
        ]
        for (name, pipeline) in variants {
            try await pipeline.png().write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // endsnippet
    }

    static let effectsLimits = Example("effects.limits") {
        // snippet: effects.limits
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 200)

        func attempt(_ name: String, _ build: () throws -> Hokusai) {
            do { _ = try build(); print(name, "→ accepted") }
            catch { print(name, "→ throws", error) }
        }

        attempt("blur(sigma: 0)") { try image.blur(sigma: 0) }
        attempt("gamma(20)") { try image.gamma(20) }
        attempt("median(size: 200)") { try image.median(size: 200) }
        attempt("dilate(radius: 60)") { try image.dilate(radius: 60) }
        attempt("threshold(300)") { try image.threshold(300) }
        attempt("edges(.canny(sigma: 50))") { try image.edges(.canny(sigma: 50)) }
        // endsnippet
    }
}
