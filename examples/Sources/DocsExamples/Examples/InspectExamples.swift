import Foundation
import Hokusai

extension Example {
    static let inspectMetadata = Example("inspect.metadata") {
        // snippet: inspect.metadata
        _ = try await Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 300).pdf().write(to: URL(fileURLWithPath: "page.pdf"))

        for name in ["scene.png", "phone.jpg", "emblem.png", "page.pdf"] {
            let m = try await Hokusai(url: URL(fileURLWithPath: name)).metadata()
            print(name, "→", m.format?.rawValue ?? "unknown", "\(m.width)×\(m.height)",
                  "oriented \(m.orientedSize.width)×\(m.orientedSize.height)",
                  "· channels", m.pixel.channels, "alpha", m.pixel.hasAlpha, m.pixel.interpretation,
                  "· pages", m.pages.count, "· exif", m.exif?.count ?? 0, "bytes",
                  "· source", m.sourceByteSize.map(String.init) ?? "n/a", "bytes")
        }

        // metadata() describes the source as opened, never the pipeline built on it.
        let original = try await Hokusai(url: URL(fileURLWithPath: "scene.png")).metadata()
        let afterResize = try await Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 100).metadata()
        print("same metadata after resize:", original == afterResize)

        // A truncated header is an error from metadata(); a file with an intact header reads even if its pixels are damaged.
        let bytes = try Data(contentsOf: URL(fileURLWithPath: "scene.png"))
        let damaged = try await Hokusai(data: bytes.prefix(bytes.count / 2)).metadata()
        print("half a PNG still reports", damaged.width, "×", damaged.height)
        // endsnippet
    }
}
