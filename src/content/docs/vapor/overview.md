---
title: Hokusai Vapor
---

Hokusai Vapor connects Hokusai 1.0 pipelines to Vapor 4. Decode an image upload, compose a recipe, and return an asynchronous image or PDF response.

## Install

```swift
dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
    .package(url: "https://github.com/ivantokar/hokusai-vapor.git", from: "1.0.0")
]
```

Add `HokusaiVapor` to the target that defines your routes. Hokusai's native requirements remain the same: install libvips, Cairo, and `pkg-config` on the host.

## Configure once

```swift
import Vapor
import HokusaiVapor

func configure(_ app: Application) throws {
    try app.hokusai.configure()
    try routes(app)
}
```

`configure()` initializes Hokusai's native image runtime. Do not add a Vapor lifecycle shutdown hook; ordinary process teardown is handled safely by Hokusai.

## First route

```swift
app.post("resize") { req async throws -> Response in
    let image = try req.hokusaiImage()
    let resized = try image.resize(width: 800, height: 600, fit: .cover)
    return try await resized.response(format: "jpeg", quality: 85)
}
```

```bash
curl -X POST http://localhost:8080/resize \
  --data-binary "@photo.jpg" \
  -o output.jpg
```

Continue with [uploads and responses](/oss/hokusai/vapor/uploads-and-responses) for raw bodies, multipart files, PDF output, and optional example routes.
