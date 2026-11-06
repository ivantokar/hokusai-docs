import Foundation
import Hokusai

extension Example {
    static let resizeBasic = Example("resize.basic") {
        // snippet: resize.basic
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png"))

        // One dimension: the aspect ratio is kept.
        try await image.resize(width: 400).webp(quality: 85)
            .write(to: URL(fileURLWithPath: "width-400.webp"))

        // Both dimensions: `fit` decides how the image meets the box (default: .cover).
        try await image.resize(width: 400, height: 400).webp(quality: 85)
            .write(to: URL(fileURLWithPath: "box-400.webp"))
        // endsnippet
    }

    static let resizeFits = Example("resize.fits") {
        // snippet: resize.fits
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png"))
        let box = (width: 480, height: 480)

        let fits: [(String, ResizeFit)] = [
            ("cover", .cover), ("contain", .contain), ("fill", .fill),
            ("inside", .inside), ("outside", .outside),
        ]
        for (name, fit) in fits {
            try await image
                .resize(width: box.width, height: box.height, fit: fit,
                        background: Color(red: 0.93, green: 0.93, blue: 0.9))
                .png()
                .write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // endsnippet
    }

    static let resizePositions = Example("resize.positions") {
        // snippet: resize.positions
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png"))

        // A square cover crop keeps only part of the landscape. `position` chooses which part.
        let positions: [(String, ResizePosition)] = [
            ("center", .center), ("west", .west), ("east", .east),
            ("attention", .attention), ("entropy", .entropy),
        ]
        for (name, position) in positions {
            try await image
                .resize(width: 360, height: 360, fit: .cover, position: position)
                .png()
                .write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // endsnippet
    }

    static let resizeEnlargement = Example("resize.enlargement") {
        // snippet: resize.enlargement
        let small = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 100)

        // Without a guard, a larger width enlarges the 100-pixel image.
        let enlarged = try await small.resize(width: 300).png().data()
        // withoutEnlargement leaves an image that is already smaller than the request alone.
        let guarded = try await small.resize(width: 300, withoutEnlargement: true).png().data()
        // withoutReduction is the opposite guard: it only ever makes the image larger.
        let notReduced = try await small.resize(width: 50, withoutReduction: true).png().data()

        print("enlarged", enlarged.info.width, "guarded", guarded.info.width, "not reduced", notReduced.info.width)
        try guarded.data.write(to: URL(fileURLWithPath: "guarded.png"))
        try enlarged.data.write(to: URL(fileURLWithPath: "enlarged.png"))
        // endsnippet
    }

    static let resizeGuards = Example("resize.guards") {
        // snippet: resize.guards
        // A 100 × 100 image and a 480 × 480 request that would enlarge it.
        let small = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 100)

        for (name, fit) in [("inside", ResizeFit.inside), ("contain", .contain), ("cover", .cover)] {
            do {
                let output = try await small
                    .resize(width: 480, height: 480, fit: fit, withoutEnlargement: true, background: .white)
                    .png().data()
                print(name, "→", output.info.width, "×", output.info.height)
            } catch {
                print(name, "→ throws", error)
            }
        }
        // endsnippet
    }

    static let resizeKernels = Example("resize.kernels") {
        // snippet: resize.kernels
        let image = try Hokusai(url: URL(fileURLWithPath: "emblem.png"))

        // Shrinking and then viewing 4× larger shows how each kernel resamples.
        let kernels: [(String, ResizeKernel)] = [
            ("nearest", .nearest), ("linear", .linear), ("cubic", .cubic),
            ("mitchell", .mitchell), ("lanczos3", .lanczos3),
        ]
        for (name, kernel) in kernels {
            try await image
                .resize(width: 40, kernel: kernel)   // shrink to 40 pixels
                .resize(width: 160, kernel: .nearest) // enlarge with .nearest only to make pixels visible
                .png()
                .write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // endsnippet
    }
}

let allExamples: [Example] = [
    .resizeBasic, .resizeFits, .resizePositions, .resizeEnlargement, .resizeGuards, .resizeKernels,
    .extractRegion, .extendCanvas, .trimBorders, .smartCropExample, .rotateAngles, .flipFlop, .autoOrientExample, .affineExample, .geometryLimits,
    .blurSigma, .sharpenExample, .toneExample, .colorSpaces, .filtersExample, .effectsLimits,
    .channelsExtract, .channelsWithAlpha, .channelsFlatten,
    .textLayouts, .textStyles, .textMarkup, .textDraw, .textLimits,
    .compositePlacement, .compositeBlend, .compositeSpace, .compositeOrder,
    .encodeFormats, .encodeQuality, .encodePNG, .encodeAlphaJPEG, .encodeTerminals, .encodeMetadata,
    .pdfRaster, .pdfVector, .pdfLimits,
    .inputOptions, .inputPages, .inputRaw, .inputSpool,
    .orderResizeBlur, .orderResizeSharpen, .orderOrientation, .orderFlatten, .orderTrimExtend, .orderComposite, .orderEncoder,
    .recipeSocialCard, .recipeThumbnails, .recipeWatermark, .recipeAvatar, .recipeContactSheet, .recipeReport, .recipeUpload,
    .runtimeCapabilities, .runtimeConfigure,
    .inspectMetadata,
    .nioBuffers,
]
