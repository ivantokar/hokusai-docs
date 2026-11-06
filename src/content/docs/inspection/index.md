---
pageId: inspection.index
title: Inspection
description: Reading what a source contains.
---

`metadata()` is `async` and reports what the root source said when it was opened; it never describes the transformed pipeline. It reads only the header.

`ImageMetadata` carries the format, stored and oriented size, an `orientation`, a `PixelMetadata` (channels, alpha, interpretation, sample format), `PageMetadata`, optional `AnimationMetadata`, an `ImageDensity` and the embedded EXIF, ICC, XMP and IPTC blocks. What a pipeline will produce is described by `OutputInfo` instead.

From the command line use `hokusai inspect` (`--json` for scripts).

:::note[Detailed guides are in progress]
This page lists what Hokusai provides in the documented release. Operation-by-operation guides with parameters, defaults, visual results and interactions are being added; the precise API contract is in the source comments of the library.
:::

## Read next

- [Sources & input](/oss/hokusai/sources-input/)
- [CLI reference](/oss/hokusai/reference/cli)
