---
pageId: guide.pipelines
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

Hokusai has no public shutdown call: do not add a shutdown hook to your server lifecycle.

## Metadata

Inspect the source's metadata before you make layout decisions. `metadata()` is asynchronous and describes the source as it was opened, not the transformed pipeline:

```swift
let image = try Hokusai(data: upload)
let metadata = try await image.metadata()
print("\(metadata.width) × \(metadata.height)")
```

What the output keeps is a `MetadataPolicy` selected with `metadataPolicy(_:)`. By default EXIF, XMP, IPTC and comments are removed while the ICC profile, orientation and density are kept; use `.preserveAll` only when a downstream consumer needs the embedded metadata.
