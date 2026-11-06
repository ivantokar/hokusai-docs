import Foundation
import Hokusai

/// The average absolute difference between two same-size pipelines, 0 (identical) to 255.
private func meanDifference(_ a: Hokusai, _ b: Hokusai) async throws -> Double {
    let diff = try a.composite([CompositeLayer(b, blend: .difference)]).convert(to: .grayscale)
    let raw = try await diff.raw(.gray8)
    let total = raw.data.reduce(0) { $0 + Int($1) }
    return Double(total) / Double(raw.data.count)
}

extension Example {
    static let orderResizeBlur = Example("order.resize-blur") {
        // snippet: order.resize-blur
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png"))
        let focus = (x: 360, y: 40, width: 220, height: 220)      // the lighthouse, after resizing to 640 px

        // A: blur the full-size image, then shrink it.   B: shrink, then blur at the final size.
        let blurThenResize = try image.blur(sigma: 6).resize(width: 640)
        let resizeThenBlur = try image.resize(width: 640).blur(sigma: 6)

        for (name, pipeline) in [("blur-then-resize", blurThenResize), ("resize-then-blur", resizeThenBlur)] {
            try await pipeline.extract(x: focus.x, y: focus.y, width: focus.width, height: focus.height)
                .png().write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // Blurring at 1600 px with sigma 6 is a much smaller blur once scaled to 640 px.
        print("mean difference:", try await meanDifference(blurThenResize, resizeThenBlur))
        // endsnippet
    }

    static let orderResizeSharpen = Example("order.resize-sharpen") {
        // snippet: order.resize-sharpen
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png"))
        let focus = (x: 360, y: 40, width: 220, height: 220)

        let sharpenThenResize = try image.sharpen(sigma: 1.5).resize(width: 640)
        let resizeThenSharpen = try image.resize(width: 640).sharpen(sigma: 1.5)
        let plain = try image.resize(width: 640)

        for (name, pipeline) in [("plain", plain), ("sharpen-then-resize", sharpenThenResize), ("resize-then-sharpen", resizeThenSharpen)] {
            try await pipeline.extract(x: focus.x, y: focus.y, width: focus.width, height: focus.height)
                .png().write(to: URL(fileURLWithPath: "\(name).png"))
        }
        print("sharpen-then-resize vs plain:", try await meanDifference(sharpenThenResize, plain))
        print("resize-then-sharpen vs plain:", try await meanDifference(resizeThenSharpen, plain))
        // endsnippet
    }

    static let orderOrientation = Example("order.orientation") {
        // snippet: order.orientation
        let phone = try Hokusai(url: URL(fileURLWithPath: "phone.jpg"))     // stored 1000 × 1600, orientation 6

        let orientFirst = try phone.autoOrient().resize(width: 800)
        let resizeFirst = try phone.resize(width: 800).autoOrient()

        for (name, pipeline) in [("orient-first", orientFirst), ("resize-first", resizeFirst)] {
            let output = try await pipeline.jpeg().data()
            print(name, "→", output.info.width, "×", output.info.height)
            try output.data.write(to: URL(fileURLWithPath: "\(name).jpg"))
        }
        // endsnippet
    }

    static let orderFlatten = Example("order.flatten") {
        // snippet: order.flatten
        let emblem = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 160)
        let paper = Color(red: 0.96, green: 0.94, blue: 0.88)

        // A: rotate, then flatten: the exposed corners are painted with the paper colour.
        let rotateThenFlatten = try emblem.rotate(by: 30).flatten(background: paper)
        // B: flatten, then rotate: the new corners are transparent again, and JPEG turns them black.
        let flattenThenRotate = try emblem.flatten(background: paper).rotate(by: 30)

        try await rotateThenFlatten.jpeg(quality: 90).write(to: URL(fileURLWithPath: "rotate-then-flatten.jpg"))
        try await flattenThenRotate.jpeg(quality: 90).write(to: URL(fileURLWithPath: "flatten-then-rotate.jpg"))
        // endsnippet
    }

    static let orderTrimExtend = Example("order.trim-extend") {
        // snippet: order.trim-extend
        let emblem = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 160).flatten(background: .white)

        // Pad, then trim: trim removes the padding it just got, because it matches the top-left pixel.
        let padThenTrim = try emblem.extend(top: 30, left: 30, bottom: 30, right: 30,
                                            mode: .background(.white)).trim()
        // Trim, then pad: the padding is added after the border is gone, so it stays.
        let trimThenPad = try emblem.trim().extend(top: 30, left: 30, bottom: 30, right: 30,
                                                   mode: .background(.white))

        for (name, pipeline) in [("pad-then-trim", padThenTrim), ("trim-then-pad", trimThenPad)] {
            let output = try await pipeline.png().data()
            print(name, "→", output.info.width, "×", output.info.height)
            try output.data.write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // endsnippet
    }

    static let orderComposite = Example("order.composite") {
        // snippet: order.composite
        let photo = try Hokusai(url: URL(fileURLWithPath: "scene.png"))
        let logo = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 200)
        let layer = CompositeLayer(logo, x: 40, y: 40)

        // A: composite on the full-size photo, then shrink: the logo shrinks with it.
        let compositeThenResize = try photo.composite([layer]).resize(width: 400)
        // B: shrink the photo, then composite at the same coordinates: the logo keeps its size.
        let resizeThenComposite = try photo.resize(width: 400).composite([layer])
        // C: blur after compositing blurs the logo too; blurring only the photo keeps the logo sharp.
        let blurAll = try photo.composite([layer]).resize(width: 400).blur(sigma: 3)
        let blurPhotoOnly = try photo.resize(width: 400).blur(sigma: 3).composite([CompositeLayer(logo.resize(width: 60), x: 12, y: 12)])

        let all: [(String, Hokusai)] = [("composite-then-resize", compositeThenResize), ("resize-then-composite", resizeThenComposite),
                                        ("blur-all", blurAll), ("blur-photo-only", blurPhotoOnly)]
        for (name, pipeline) in all {
            try await pipeline.webp(quality: 85).write(to: URL(fileURLWithPath: "\(name).webp"))
        }
        // endsnippet
    }

    static let orderEncoder = Example("order.encoder") {
        // snippet: order.encoder
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png"))

        // The encoder is terminal configuration, not an image operation: where it appears does not matter,
        // and the last one wins.
        let early = try await image.jpeg(quality: 70).resize(width: 300).data()
        let late = try await image.resize(width: 300).jpeg(quality: 70).data()
        let replaced = try await image.png().webp(quality: 70).resize(width: 300).data()

        print("encoder first == encoder last:", early.data == late.data)
        print("png() then webp() →", replaced.info.format.rawValue)
        // endsnippet
    }
}
