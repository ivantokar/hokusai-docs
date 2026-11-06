---
title: Uploads & Responses
---

Hokusai Vapor loads a request into a normal immutable `Hokusai` pipeline. Transform it as you would in any Swift application, then await a typed HTTP response.

## Raw request body

```swift
app.post("resize") { req async throws -> Response in
    let image = try req.hokusaiImage()
    let resized = try image.resize(width: 800, height: 600, fit: .cover)
    return try await resized.response(format: "jpeg", quality: 85)
}
```

The request body must contain encoded image bytes. A missing or unreadable body returns `400 Bad Request`.

## Multipart upload

```swift
app.post("upload") { req async throws -> Response in
    let image = try req.hokusaiImage(field: "image")
    let thumbnail = try image.resize(width: 200, height: 200, fit: .cover)
    return try await thumbnail.response(format: "png", compression: 6)
}
```

The field name must match the multipart file field. Missing fields and unreadable file data return `400 Bad Request`.

## Output formats

`response` evaluates the pipeline asynchronously and sets the matching `Content-Type` header:

```swift
try await image.response(format: "jpeg", quality: 85)
try await image.response(format: "png", compression: 6)
try await image.response(format: "webp", quality: 82)
try await image.response(format: "avif", quality: 50)
try await image.response(format: "pdf")
```

PDF responses are one-page, Cairo-backed raster documents. They suit generated image reports and layered compositions, but do not preserve selectable vector text.

## Optional example routes

Register `ImageProcessingRoutes` for simple raw-body examples:

```swift
try ImageProcessingRoutes.register(to: app.grouped("api", "images"))
```

- `POST /api/images/text?text=Hello&fontSize=48`
- `POST /api/images/convert?format=webp&quality=82`

Both accept the source image as the raw request body.
