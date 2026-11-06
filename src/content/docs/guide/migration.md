---
pageId: guide.migration
title: Migration
---

Hokusai uses immutable `Hokusai` pipelines and asynchronous output terminals. This page maps the earlier adapter-style 0.x API to the current one and lists behavior changes between 2.x releases.

## From 0.x {#from-0x}

| 0.x adapter API | Current pipeline API |
| --- | --- |
| `Hokusai.image(from: path)` | `Hokusai(url: URL(fileURLWithPath: path))` |
| `Hokusai.image(from: data)` | `Hokusai(data: data)` |
| `image.resize(...).toFile(path)` | `try await pipeline.resize(...).write(to: URL(...))` |
| `image.crop(...)` | `pipeline.extract(x:y:width:height:)` |
| `image.toBuffer(...)` | Select an encoder, then `try await .data()` |

### Migration rules {#migration-rules}

1. Replace loaded image adapters with a `Hokusai` value constructed from `Data` or a file `URL`.
2. Build transforms without `await`; the transformed value is still a recipe.
3. Await only the terminals: `data()`, `write(to:)`, `writeChunks`, `raw` and `metadata()`.
4. The `HokusaiLegacy` compatibility product is not part of the 2.x packages.

## Within 2.x {#within-2x}

- **2.1.0:** `clahe` equalises lightness and keeps colour, so colour results differ from earlier releases. `write(to:)` and the CLI refuse a destination that the pipeline reads; write to a different file and replace the original afterwards.
- **2.2.0:** the `resize`, `thumbnail`, `convert`, `rotate`, `crop` and `text` commands are deprecated in favor of `hokusai run` and will be removed in the next major version. Their defaults now match the library: `resize` fits with `cover` (it was `inside`), and text is 24 points, black.
- **Metadata:** output now keeps the ICC profile, orientation and density by default and removes EXIF, XMP, IPTC and comments; earlier versions removed everything.

See the [changelog](/oss/hokusai/changelog) for the full list.
