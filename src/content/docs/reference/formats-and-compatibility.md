---
pageId: reference.formats-and-compatibility
title: Formats & Compatibility
---

## Inputs and outputs

Create a pipeline from image `Data` or a local file `URL`:

```swift
let fromData = try Hokusai(data: uploadData)
let fromFile = try Hokusai(url: URL(fileURLWithPath: "photo.jpg"))
```

Use a typed encoder to produce one of Hokusai's v1 output formats:

| Format | Pipeline encoder | Typical control |
| --- | --- | --- |
| JPEG | `.jpeg()` | quality, progressive |
| PNG | `.png()` | compression level, progressive |
| WebP | `.webp()` | quality, effort, lossless |
| AVIF | `.avif()` | quality |
| PDF | `.pdf()` | page size, DPI |

`write(to:)` can infer the output format from the file extension where supported. Select a typed encoder explicitly when you need encoder-specific controls.

## Platform support

Hokusai supports macOS 13+ and Ubuntu/Debian Linux with Swift 6.0+, libvips 8.9+, Cairo, and `pkg-config` installed. PDF output requires Cairo support in the installed libvips environment.

## Version 1.0 compatibility

Version 1.0 is a breaking release. The public API now uses immutable pipelines and asynchronous terminal evaluation. See [Migrating from 0.x](/oss/hokusai/guide/migration) for the API mapping.

The `HokusaiLegacy` product is available for intentional, temporary adoption of 0.x adapters. It should not be used for new application code.
