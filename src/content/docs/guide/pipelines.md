---
title: Pipelines & Concurrency
---

Hokusai values represent a recipe, not evaluated image pixels. Each transformation creates a new immutable value, so a source pipeline can be reused safely.

```swift
let source = try Hokusai(url: URL(fileURLWithPath: "photo.jpg"))
let card = source.resize(width: 1200, height: 630, fit: .cover)
let thumbnail = source.resize(width: 400)

async let cardData = card.webp(quality: 82).data()
async let thumbnailData = thumbnail.jpeg(quality: 85).data()
let outputs = try await (cardData, thumbnailData)
```

## Evaluation terminals

Pipelines are evaluated only by output terminals:

- `data()` returns encoded bytes and output information.
- `write(to:)` encodes and writes to a file `URL`.

Those terminals run blocking libvips work off Swift's cooperative executor. Build transformations normally; await only when work must be evaluated.

## Runtime lifecycle

Loading an image initializes the runtime lazily. Calling `Hokusai.initialize()` is optional but useful at app startup to surface native dependency problems before serving traffic.

Do not call `Hokusai.shutdown()` during normal application or server lifecycle handling. It is only for final process teardown in short-lived tools after native images have been released.

## Metadata

Inspect a pipeline's source metadata before you make layout decisions:

```swift
let image = try Hokusai(data: upload)
let metadata = try image.metadata()
print("\(metadata.width) × \(metadata.height)")
```

Output metadata is removed by default. Call `preserveMetadata()` only when a downstream consumer needs embedded metadata.
