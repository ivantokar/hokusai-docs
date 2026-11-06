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

Use a typed encoder to produce one of Hokusai's output formats:

| Format | Pipeline encoder | Typical control |
| --- | --- | --- |
| JPEG | `.jpeg()` | quality, progressive, chroma subsampling |
| PNG | `.png()` | compression level, interlaced, palette |
| WebP | `.webp()` | quality, effort, lossless, preset |
| AVIF | `.avif()` | quality, effort, lossless, bit depth |
| HEIF | `.heif()` | compression (`hevc`, `av1`), quality, lossless |
| TIFF | `.tiff()` | compression, quality, predictor, tiling |
| GIF | `.gif()` | bit depth, dither, effort, interlaced |
| PDF | `.pdf()` | page size, margins, anchor, background, max effective DPI, metadata |

`write(to:)` can infer the output format from the file extension where supported. Select a typed encoder explicitly when you need encoder-specific controls.

## Platform support

Hokusai supports macOS 13+ and Linux with Swift 6.0+, libvips 8.16+, Cairo 1.16+ with PDF support, and `pkg-config` installed. Which formats can be read or written beyond the baseline depends on how libvips was built: call `Hokusai.capabilities()` or run `hokusai info` to see what your installation supports.

## Compatibility

The public API uses immutable pipelines and asynchronous terminal evaluation. See [Migration](/oss/hokusai/guide/migration) for the API mapping and for behavior changes between releases.
