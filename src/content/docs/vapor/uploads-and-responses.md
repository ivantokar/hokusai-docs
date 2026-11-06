---
pageId: vapor.uploads-and-responses
title: Uploads & Responses
---

Hokusai Vapor loads a request into a normal immutable `Hokusai` pipeline. Transform it as you would in any Swift application, choose the encoder, then return a streamed HTTP response.

## Raw request body

```swift
app.post("resize") { req async throws -> Response in
    try await req.hokusaiImage()
        .resize(width: 800, height: 600, fit: .cover)
        .jpeg(quality: 85)
        .response()
}
```

The request body must contain encoded image bytes. The body is read as it arrives, never beyond `maximumSize` (20 MiB by default): a declared `Content-Length` over the limit is rejected before any byte is read, and a body without one is rejected as soon as it grows past it, both with `413`. A small upload stays in memory; one larger than `memoryLimit` (1 MiB by default) moves to a private temporary file. A missing or unreadable body returns `400 Bad Request`.

## Multipart upload

```swift
app.post("upload") { req async throws -> Response in
    try await req.hokusaiImage(field: "image")
        .resize(width: 200, height: 200, fit: .cover)
        .png()
        .response()
}
```

The field name must match the multipart file field. Missing fields and unreadable file data return `400 Bad Request`.

## Output formats

Choose the encoder on the pipeline, then call `response()`. `Content-Type` comes from the format the encoder produces, and the body is written as it is encoded, so a slow client slows encoding down instead of growing memory:

```swift
try await image.jpeg(quality: 85).response()
try await image.png().response()
try await image.webp(quality: 82).response(headers: ["Cache-Control": "public, max-age=3600"])
try await image.avif(quality: 50).response()
try await image.pdf().response()
```

PDF responses are one-page, Cairo-backed raster documents. They suit generated image reports and layered compositions, but do not preserve selectable vector text.

## Optional example routes

Register `ImageProcessingRoutes` for simple raw-body examples:

```swift
try ImageProcessingRoutes.register(to: app.grouped("api", "images"))
```

- `POST /api/images/text?text=Hello&fontSize=48` (also `font`, `strokeWidth`, `quality`)
- `POST /api/images/convert?format=webp&quality=82` (also `compression`)

Both accept the source image as the raw request body.

## Errors {#errors}

`HokusaiError` maps to a status by its case: `invalidInput` and `invalidOption` give 400, `decode` 422, `resource` 413 for bytes, 422 for pixels or channels and 503 for the evaluation queue, `unsupported` 501, and `io`, `transform`, `encode` and `runtime` 500. `response()` and `hokusaiImage` already apply the mapping; for a route that evaluates a pipeline itself with `data()` or `write(to:)`, add `HokusaiErrorMiddleware()`.
