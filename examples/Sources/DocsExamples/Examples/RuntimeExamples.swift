import Foundation
import Hokusai

extension Example {
    static let runtimeCapabilities = Example("runtime.capabilities") {
        // snippet: runtime.capabilities
        let capabilities = try Hokusai.capabilities()
        print("libvips", capabilities.libvipsVersion, "· Cairo", capabilities.cairoVersion)
        print("can read :", capabilities.inputFormats.map(\.rawValue).sorted().joined(separator: ", "))
        print("can write:", capabilities.outputFormats.map(\.rawValue).sorted().joined(separator: ", "))
        print("text rendering:", capabilities.textRendering, "· HEIF codecs:",
              capabilities.heifCompressions.map { "\($0)" }.sorted().joined(separator: ", "), "· PNG palette:", capabilities.pngPalette)
        // endsnippet
    }

    static let runtimeConfigure = Example("runtime.configure") {
        // snippet: runtime.configure
        // Configuration is chosen once, before the runtime is first used.
        try Hokusai.configure(.init(
            maxConcurrentEvaluations: .fixed(1),
            maxQueuedEvaluations: 1,
            maxOutputPixels: 50_000_000
        ))
        let status = Hokusai.runtimeStatus
        print("frozen yet?", status.isConfigurationFrozen, "· limit", status.maxConcurrentEvaluations)

        // A second call after the runtime has started is refused.
        _ = try Hokusai.capabilities()
        do { try Hokusai.configure(.init()) } catch { print("configure after use →", error) }

        // One slot and one waiting place: of five simultaneous requests, some are rejected up front.
        let source = try Hokusai(url: URL(fileURLWithPath: "scene.png"))
        var finished = 0, rejected = 0
        await withTaskGroup(of: Bool.self) { group in
            for _ in 0..<5 {
                group.addTask {
                    do { _ = try await source.blur(sigma: 8).webp().data(); return true }
                    catch { return false }
                }
            }
            for await ok in group { if ok { finished += 1 } else { rejected += 1 } }
        }
        print("finished:", finished, "rejected:", rejected)

        // maxOutputPixels refuses a pipeline that would create an absurd canvas, before computing anything.
        do { _ = try await source.resize(width: 100_000).png().data() } catch { print("huge resize →", error) }
        // endsnippet
    }
}
