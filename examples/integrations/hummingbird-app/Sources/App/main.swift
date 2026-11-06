import Hokusai
import HokusaiHummingbird
import Hummingbird

// snippet: integrations.hummingbird
func buildRouter() -> Router<BasicRequestContext> {
    let router = Router()
    router.add(middleware: HokusaiErrorMiddleware())

    // POST /resize --data-binary @photo.jpg
    router.post("resize") { request, _ -> Response in
        let image = try await request.hokusaiImage(maximumSize: 5 * 1024 * 1024)   // 413 above 5 MiB
        return try await image
            .resize(width: 800, height: 600, fit: .cover)
            .webp(quality: 82)                       // choose the encoder on the pipeline
            .response()                              // Content-Type: image/webp, streamed
    }

    // An A4 PDF of the upload
    router.post("report") { request, _ -> Response in
        let image = try await request.hokusaiImage()
        return try await image
            .resize(width: 1240, height: 1754, fit: .contain)
            .pdf(pageSize: .a4(), margins: .all(36), background: .white)
            .response(status: .created, headers: [.cacheControl: "no-store"])
    }
    return router
}

@main
struct Entry {
    static func main() async throws {
        // Hokusai's process-level settings are frozen at first use, so set them before the first request.
        try Hokusai.configure(.init(maxConcurrentEvaluations: .fixed(4), maxQueuedEvaluations: 64))
        try Hokusai.initialize()
        let app = Application(router: buildRouter(), configuration: .init(address: .hostname("127.0.0.1", port: 8080)))
        try await app.runService()
    }
}
// endsnippet
