---
pageId: pdf.index
title: PDF
description: Raster PDF export and vector PDF documents.
---

Two different things produce PDF files.

| | Raster export | Vector documents |
| --- | --- | --- |
| API | `image.pdf(pageSize:margins:anchor:background:maxEffectiveDPI:metadata:)` | `VectorDocument` of `VectorPage`s |
| Module | Hokusai | HokusaiPDF |
| Content | The evaluated pipeline as one raster page | Backgrounds, rectangles, lines, images and real, selectable text |
| Needs | Cairo with PDF support | Pango 1.44 or newer |

Raster pages are sized from the image (`.image(dpi:)`), as `.a4`, `.letter` or exact `.points`. Vector text is laid out by Pango with a typed `VectorTextStyle` and can be plain or markup; fills can be solid colours or linear gradients.

:::note[Detailed guides are in progress]
This page lists what Hokusai provides in the documented release. Operation-by-operation guides with parameters, defaults, visual results and interactions are being added; the precise API contract is in the source comments of the library.
:::

## Read next

- [Text, composition & PDF](/oss/hokusai/guide/composition-and-pdf)
- [Encoding & output](/oss/hokusai/encoding-output/)
