import Foundation
import Hokusai

extension Example {
    static let channelsExtract = Example("channels.extract") {
        // snippet: channels.extract
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 360)

        for (name, channel) in [("red", Channel.red), ("green", .green), ("blue", .blue), ("luminance", .luminance)] {
            try await image.extractChannel(channel).png().write(to: URL(fileURLWithPath: "\(name).png"))
        }

        // The alpha channel of an image that has one (the emblem's transparent corners are black).
        try await Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 200)
            .extractChannel(.alpha).png().write(to: URL(fileURLWithPath: "emblem-alpha.png"))
        // endsnippet
    }

    static let channelsWithAlpha = Example("channels.with-alpha") {
        // snippet: channels.with-alpha
        let photo = try Hokusai(url: URL(fileURLWithPath: "scene.png"))
        let mask = try Hokusai(url: URL(fileURLWithPath: "mask.png"))     // 1600 × 1000, black → white ramp

        // White keeps a pixel, black hides it: the photo fades out towards the left.
        try await photo.withAlpha(from: mask).resize(width: 480).png()
            .write(to: URL(fileURLWithPath: "faded.png"))

        // The mask must be the same size as the image.
        do {
            _ = try await photo.withAlpha(from: mask.resize(width: 800)).png().data()
        } catch {
            print("size mismatch → throws", error)
        }
        // endsnippet
    }

    static let channelsFlatten = Example("channels.flatten") {
        // snippet: channels.flatten
        let emblem = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 200)
        let paper = Color(red: 0.96, green: 0.94, blue: 0.88)

        try await emblem.flatten(background: paper).png().write(to: URL(fileURLWithPath: "flatten.png"))
        // removeAlpha drops the channel without compositing: transparent pixels show their raw colour.
        try await emblem.removeAlpha().png().write(to: URL(fileURLWithPath: "remove-alpha.png"))

        // ensureAlpha adds an opaque (or constant-opacity) channel when there is none.
        let opaque = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 200)
        let before = try await opaque.png().data()
        let after = try await opaque.ensureAlpha(opacity: 0.5).png().data()
        for (name, output) in [("scene-rgb", before), ("scene-half-alpha", after)] {
            let meta = try await Hokusai(data: output.data).metadata()
            print(name, "→ alpha:", meta.pixel.hasAlpha, "channels:", meta.pixel.channels)
        }
        try after.data.write(to: URL(fileURLWithPath: "half-alpha.png"))

        // JPEG has no alpha, so the encoder needs it flattened.
        try await emblem.flatten(background: paper).jpeg(quality: 90).write(to: URL(fileURLWithPath: "emblem.jpg"))
        // endsnippet
    }
}
