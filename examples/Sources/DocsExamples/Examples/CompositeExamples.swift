import Foundation
import Hokusai

extension Example {
    static let compositePlacement = Example("composite.placement") {
        // snippet: composite.placement
        let photo = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 560)
        let logo = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 90)

        let placements: [(String, Placement, Double)] = [
            ("at", .at(x: 20, y: 20), 1),
            ("gravity", .gravity(.southEast, offsetX: 16, offsetY: 16), 0.85),
            ("clipped", .at(x: -45, y: 300), 1),                       // partly outside: clipped to the base
            ("tile", .tile(gravity: .northWest), 0.25),
        ]
        for (name, placement, opacity) in placements {
            try await photo
                .composite([CompositeLayer(logo, placement: placement, opacity: opacity)])
                .webp(quality: 85)
                .write(to: URL(fileURLWithPath: "\(name).webp"))
        }
        // endsnippet
    }

    static let compositeBlend = Example("composite.blend") {
        // snippet: composite.blend
        let photo = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 360)
        // The layer is the black-to-white ramp, resized to the photo.
        let ramp = try Hokusai(url: URL(fileURLWithPath: "mask.png")).resize(width: 360, height: 225, fit: .fill)

        let modes: [(String, BlendMode)] = [
            ("over", .over), ("multiply", .multiply), ("screen", .screen),
            ("overlay", .overlay), ("difference", .difference), ("softLight", .softLight),
        ]
        for (name, mode) in modes {
            try await photo
                .composite([CompositeLayer(ramp, blend: mode)])
                .webp(quality: 85)
                .write(to: URL(fileURLWithPath: "\(name).webp"))
        }
        // endsnippet
    }

    static let compositeSpace = Example("composite.space") {
        // snippet: composite.space
        let backdrop = try Hokusai(url: URL(fileURLWithPath: "mask.png")).resize(width: 360, height: 120, fit: .fill)
        // A single black pixel enlarged into a 360 × 120 layer, at half opacity.
        let black = try Hokusai(raw: Data([0, 0, 0]), width: 1, height: 1, format: .rgb8)
            .resize(width: 360, height: 120, fit: .fill, kernel: .nearest)

        for (name, space) in [("srgb", CompositingSpace.srgb), ("linear", .linear)] {
            try await backdrop
                .composite([CompositeLayer(black, opacity: 0.5)], space: space)
                .png()
                .write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // endsnippet
    }

    static let compositeOrder = Example("composite.order") {
        // snippet: composite.order
        let base = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 360)
        let big = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 200)
        let small = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 120).negate()

        // Later layers draw over earlier ones.
        let a = [CompositeLayer(big, x: 90, y: 10), CompositeLayer(small, x: 150, y: 50)]
        try await base.composite(a).webp(quality: 85).write(to: URL(fileURLWithPath: "small-on-top.webp"))
        try await base.composite(a.reversed()).webp(quality: 85).write(to: URL(fileURLWithPath: "big-on-top.webp"))

        // A layer is a pipeline of its own: its transformations apply, its encoder choice is ignored.
        let blurred = try big.blur(sigma: 6).png()
        try await base.composite([CompositeLayer(blurred, x: 90, y: 10)]).webp(quality: 85)
            .write(to: URL(fileURLWithPath: "layer-pipeline.webp"))
        // endsnippet
    }
}
