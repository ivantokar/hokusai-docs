import Foundation
import Hokusai

extension Example {
    static let extractRegion = Example("geometry.extract") {
        // snippet: geometry.extract
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png"))

        // Coordinates count from the top-left corner of the image *as it is at this point*.
        try await image
            .extract(x: 1000, y: 120, width: 400, height: 560)
            .png()
            .write(to: URL(fileURLWithPath: "lighthouse.png"))

        // After a resize, the same numbers address a different part of the picture.
        try await image
            .resize(width: 800)
            .extract(x: 1000 / 2, y: 120 / 2, width: 400 / 2, height: 560 / 2)
            .png()
            .write(to: URL(fileURLWithPath: "lighthouse-after-resize.png"))
        // endsnippet
    }

    static let extendCanvas = Example("geometry.extend") {
        // snippet: geometry.extend
        let emblem = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 160)
        let paper = Color(red: 0.96, green: 0.94, blue: 0.88)

        // To an exact size, anchored, filled with a colour.
        try await emblem.extend(to: ImageSize(width: 320, height: 200), anchor: .west, background: paper)
            .png().write(to: URL(fileURLWithPath: "to-size.png"))

        // Padding on each side, filled by the image's own edge pixels.
        let modes: [(String, ExtendMode)] = [("copy", .copy), ("repeat", .repeat), ("mirror", .mirror)]
        for (name, mode) in modes {
            try await emblem.extend(top: 40, left: 40, bottom: 40, right: 40, mode: mode)
                .png().write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // endsnippet
    }

    static let trimBorders = Example("geometry.trim") {
        // snippet: geometry.trim
        // Add a plain border first, so there is something to trim.
        let framed = try Hokusai(url: URL(fileURLWithPath: "emblem.png"))
            .resize(width: 200)
            .extend(top: 30, left: 60, bottom: 30, right: 60,
                    mode: .background(Color(red: 1, green: 1, blue: 1)))

        try await framed.png().write(to: URL(fileURLWithPath: "framed.png"))
        try await framed.trim().png().write(to: URL(fileURLWithPath: "trimmed.png"))

        // Keep a margin of the background around the detected content.
        try await framed.trim(TrimOptions(margin: 12)).png()
            .write(to: URL(fileURLWithPath: "trimmed-margin.png"))
        // endsnippet
    }

    static let smartCropExample = Example("geometry.smart-crop") {
        // snippet: geometry.smart-crop
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png"))

        // smartCrop crops without resizing: it keeps a 500 × 500 window of the original pixels.
        for (name, strategy) in [("attention", SmartCropStrategy.attention), ("entropy", .entropy)] {
            try await image
                .smartCrop(width: 500, height: 500, strategy: strategy)
                .png()
                .write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // endsnippet
    }

    static let rotateAngles = Example("geometry.rotate") {
        // snippet: geometry.rotate
        let image = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 200)
        let paper = Color(red: 0.96, green: 0.94, blue: 0.88)

        // Right angles are exact: width and height swap, no resampling.
        let quarter = try await image.rotate(by: 90).png().data()
        print("90°:", quarter.info.width, "×", quarter.info.height)

        // Any other angle resamples and grows the canvas; the corners are filled with `background`.
        let tilted = try await image.rotate(by: 30, background: paper).png().data()
        print("30°:", tilted.info.width, "×", tilted.info.height)

        try quarter.data.write(to: URL(fileURLWithPath: "rotate-90.png"))
        try tilted.data.write(to: URL(fileURLWithPath: "rotate-30.png"))
        try await image.rotate(by: 30).png().write(to: URL(fileURLWithPath: "rotate-30-transparent.png"))
        // endsnippet
    }

    static let flipFlop = Example("geometry.flip-flop") {
        // snippet: geometry.flip-flop
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 360)

        try await image.flip().png().write(to: URL(fileURLWithPath: "flip.png"))   // top ↔ bottom
        try await image.flop().png().write(to: URL(fileURLWithPath: "flop.png"))   // left ↔ right
        // endsnippet
    }

    static let autoOrientExample = Example("geometry.auto-orient") {
        // snippet: geometry.auto-orient
        // phone.jpg is stored as 1000 × 1600 pixels with EXIF orientation 6 ("rotate to view").
        let phone = try Hokusai(url: URL(fileURLWithPath: "phone.jpg"))

        // Dropping the orientation tag shows the pixels exactly as stored (browsers would
        // otherwise apply the tag and display the stored image upright).
        let stored = try await phone.jpeg().metadataPolicy(.removeAll).data()
        let upright = try await phone.autoOrient().jpeg().data()        // orientation applied
        print("stored:", stored.info.width, "×", stored.info.height,
              " upright:", upright.info.width, "×", upright.info.height)

        try stored.data.write(to: URL(fileURLWithPath: "stored.jpg"))
        try upright.data.write(to: URL(fileURLWithPath: "upright.jpg"))
        // endsnippet
    }

    static let affineExample = Example("geometry.affine") {
        // snippet: geometry.affine
        let image = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 200)
        let paper = Color(red: 0.96, green: 0.94, blue: 0.88)

        // x' = a·x + b·y, y' = c·x + d·y. A shear leans the image; the output grows to fit.
        try await image
            .affine(AffineMatrix(a: 1, b: 0.4, c: 0, d: 1), edges: .background(paper))
            .png().write(to: URL(fileURLWithPath: "shear.png"))

        // A non-uniform scale, then `outputArea` crops the result.
        try await image
            .affine(AffineMatrix(a: 1.6, b: 0, c: 0, d: 0.6),
                    outputArea: AffineArea(x: 0, y: 0, width: 260, height: 100),
                    edges: .background(paper))
            .png().write(to: URL(fileURLWithPath: "scale-crop.png"))
        // endsnippet
    }
}

extension Example {
    static let geometryLimits = Example("geometry.limits") {
        // snippet: geometry.limits
        let image = try Hokusai(url: URL(fileURLWithPath: "emblem.png"))   // 400 × 400

        func attempt(_ name: String, _ pipeline: () throws -> Hokusai) async {
            do {
                let output = try await pipeline().png().data()
                print(name, "→", output.info.width, "×", output.info.height)
            } catch {
                print(name, "→ throws", error)
            }
        }

        await attempt("extract inside") { try image.extract(x: 100, y: 100, width: 200, height: 200) }
        await attempt("extract past the edge") { try image.extract(x: 300, y: 300, width: 200, height: 200) }
        await attempt("extend smaller") { try image.extend(to: ImageSize(width: 300, height: 300)) }
        await attempt("smartCrop larger") { try image.smartCrop(width: 900, height: 900) }
        await attempt("trim, nothing to trim") { try image.flatten(background: .white).trim() }
        // endsnippet
    }
}
