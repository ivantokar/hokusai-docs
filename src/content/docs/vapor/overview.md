---
pageId: vapor.overview
title: Hokusai Vapor
---

Hokusai Vapor connects Hokusai 2 pipelines to Vapor 4. Decode an image upload, compose a recipe, and return a streamed image or PDF response.

## Install

```swift
dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
    .package(url: "https://github.com/ivantokar/hokusai-vapor.git", from: "2.0.0")
]
```

Add `HokusaiVapor` to the target that defines your routes. Hokusai's native requirements remain the same: libvips 8.16+, Cairo with PDF support, and `pkg-config` on the host.

## Configure once

```swift
import Vapor
import HokusaiVapor

func configure(_ app: Application) throws {
    try app.hokusai.configure()
    try routes(app)
}
```

`configure()` accepts an optional `RuntimeConfiguration` that freezes process-level settings before the first image, for example `.init(maxConcurrentEvaluations: .fixed(4), maxQueuedEvaluations: 64)`. Without one, the defaults apply and the native runtime starts on first use. `app.hokusai.capabilities()` and `app.hokusai.runtimeStatus` report the runtime. Do not add a Vapor lifecycle shutdown hook.

## First route

```swift
app.post("resize") { req async throws -> Response in
    try await req.hokusaiImage()
        .resize(width: 800, height: 600, fit: .cover)
        .jpeg(quality: 85)
        .response()
}
```

```bash
curl -X POST http://localhost:8080/resize \
  --data-binary "@photo.jpg" \
  -o output.jpg
```

Continue with [uploads and responses](/oss/hokusai/vapor/uploads-and-responses) for raw bodies, multipart files, PDF output, and optional example routes.
