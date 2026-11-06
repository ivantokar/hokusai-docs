---
pageId: sources-input.index
title: Sources & input
description: Every way to create a Hokusai pipeline.
---

| Create a pipeline from | API | Module |
| --- | --- | --- |
| Encoded bytes | `Hokusai(data:options:)` | Hokusai |
| A file | `Hokusai(url:options:)` | Hokusai |
| Raw pixels you already hold | `Hokusai(raw:width:height:format:rowStride:premultiplied:limits:)`, `Hokusai(raw: RawImage)` | Hokusai |
| An upload that arrives in chunks | `Hokusai(spooling:options:memoryLimit:spoolDirectory:)` | Hokusai |
| NIO buffers | `Hokusai(buffer:options:byteTransferStrategy:)`, `Hokusai(spooling:)` with `ByteBuffer` | HokusaiNIO |
| Generated text | `Hokusai.text(_:layout:style:)` | Hokusai |

`InputOptions` selects the `page` of a multi-page source, the `access` mode (`random` or `sequential`), the `failOn` decode-failure level and the `limits`. `InputLimits` bounds `maxBytes`, `maxPixels` and `maxChannels` before any native work. Raw pixel formats are `gray8`, `grayAlpha8`, `rgb8`, `rgba8` and their 16-bit forms.

:::note[Detailed guides are in progress]
This page lists what Hokusai provides in the documented release. Operation-by-operation guides with parameters, defaults, visual results and interactions are being added; the precise API contract is in the source comments of the library.
:::

## Read next

- [Pipelines & concurrency](/oss/hokusai/guide/pipelines)
- [Inspection](/oss/hokusai/inspection/)
