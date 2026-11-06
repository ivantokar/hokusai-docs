# Audit of the pre-restructure site against Hokusai 2.2.2

The site described Hokusai 1.0. The current release is 2.2.2 (2026-11-06). Findings, all corrected in the restructuring PR:

| Where | Stale claim | Reality in 2.2.2 |
| --- | --- | --- |
| Home, getting started, installation | "Hokusai 1.0", `from: "1.0.0"` | 2.x; `from: "2.0.0"` |
| Installation, formats | libvips 8.9+, "Ubuntu/Debian Linux" | libvips 8.16+ (older is rejected at compile time), Cairo 1.16+, Linux; Ubuntu 24.04 and Debian 12 need a self-built libvips |
| Installation | `::: code-group` (VitePress syntax) | Not rendered by Starlight; replaced by plain sections |
| Installation, formats, migration | `HokusaiLegacy` product | Not in the 2.x packages |
| Home, formats | Outputs: JPEG, PNG, WebP, AVIF, PDF | Also HEIF, TIFF, GIF |
| Pipelines | `Hokusai.shutdown()` | No public shutdown API |
| Pipelines | `try image.metadata()`, `preserveMetadata()` | `metadata()` is `async`; `metadataPolicy(_:)` with `MetadataPolicy` |
| Transformations | `.rotate(.d90)` | `rotate(by: Double, background:interpolation:)` |
| Composition | `TextOptions`, `drawText(x:y:options:)`, color arrays | `TextStyle`, `drawText(_:placement:layout:style:)`, `Color` |
| Composition, examples | `.pdf(pageSize: .a4, dpi: 150)` | `pdf(pageSize:margins:anchor:background:maxEffectiveDPI:metadata:)`; DPI is part of `.image(dpi:)` or a limit |
| Examples, Vapor | `resized.response(format: "webp", quality: 82)` | Choose the encoder on the pipeline, then `response()` |
| Vapor | Hokusai 1.0 / `from: "1.0.0"`, buffered responses | 2.x, streamed responses with backpressure, size limits, error middleware |
| CLI | `convert --output x.pdf`, `thumbnail`, `resize` as primary commands | `hokusai run` is primary; the six older commands are deprecated and their defaults changed |
| Changelog | Only 1.0.0 | 2.0.0 – 2.2.2 |
| Whole site | No mention of Hummingbird, `HokusaiNIO`, `HokusaiPDF`, raw pixels, spooled uploads, `InputOptions`/`InputLimits`, runtime configuration, 16-bit/advanced filters | Covered by family landing pages; detailed guides follow |

Not found stale: the resize/`fit`/`position` example, `autoOrient()`, `extract`, `composite(...)`, `CompositeLayer(_:x:y:opacity:)`, `Hokusai(data:)`/`Hokusai(url:)`, `data()`/`write(to:)`.
