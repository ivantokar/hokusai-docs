import Hokusai
import HokusaiVapor
import Vapor

// snippet: integrations.vapor
func routes(_ app: Application) throws {
    // Map HokusaiError to HTTP statuses for any route that evaluates a pipeline itself.
    let images = app.grouped(HokusaiErrorMiddleware())

    // Raw body: POST /resize --data-binary @photo.jpg
    images.post("resize") { req async throws -> Response in
        try await req.hokusaiImage(maximumSize: 5 * 1024 * 1024)       // 413 above 5 MiB
            .resize(width: 800, height: 600, fit: .cover)
            .webp(quality: 82)
            .response()                                                // Content-Type: image/webp, streamed
    }

    // Multipart: POST /upload with an "image" file field
    images.post("upload") { req async throws -> Response in
        try await req.hokusaiImage(field: "image")
            .autoOrient()
            .resize(width: 256, height: 256, fit: .cover, position: .attention)
            .png()
            .response(headers: ["Cache-Control": "public, max-age=3600"])
    }

    // A large body, streamed to a temporary file instead of held in memory
    images.on(.POST, "large", body: .stream) { req async throws -> Response in
        try await req.hokusaiImage(
            options: InputOptions(limits: InputLimits(maxPixels: 50_000_000)),
            maximumSize: 200 * 1024 * 1024
        )
        .resize(width: 1600, height: 1600, fit: .inside, withoutEnlargement: true)
        .jpeg(quality: 85)
        .response()
    }
}

func configure(_ app: Application) throws {
    // Optional: freeze Hokusai's process-level settings before the first image.
    try app.hokusai.configure(.init(maxConcurrentEvaluations: .fixed(4), maxQueuedEvaluations: 64))
    try routes(app)
}
// endsnippet

@main
enum Entry {
    static func main() async throws {
        let app = try await Application.make(.detect())
        try configure(app)
        try await app.execute()
        try await app.asyncShutdown()
    }
}
