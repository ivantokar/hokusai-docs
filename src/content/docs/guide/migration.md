---
title: Migrating from 0.x
---

Hokusai 1.0 replaces the adapter-style 0.x API with immutable `Hokusai` pipelines and asynchronous output terminals.

| 0.x adapter API | 1.0 pipeline API |
| --- | --- |
| `Hokusai.image(from: path)` | `Hokusai(url: URL(fileURLWithPath: path))` |
| `Hokusai.image(from: data)` | `Hokusai(data: data)` |
| `image.resize(...).toFile(path)` | `try await pipeline.resize(...).write(to: URL(...))` |
| `image.crop(...)` | `pipeline.extract(x:y:width:height:)` |
| `image.toBuffer(...)` | Select an encoder, then `try await .data()` |

## Migration rules

1. Replace loaded image adapters with a `Hokusai` value constructed from `Data` or a file `URL`.
2. Build transforms without `await`; the transformed value is still a recipe.
3. Await only `data()` and `write(to:)`.
4. Import `HokusaiLegacy` only as a temporary compatibility bridge.

The optimized `thumbnail` CLI command intentionally retains its legacy thumbnail loader while the public 1.0 thumbnail pipeline counterpart is designed.
