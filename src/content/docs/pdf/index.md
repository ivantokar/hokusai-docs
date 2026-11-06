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

## Guides {#guides}

- [Raster PDF](/oss/hokusai/pdf/raster)
- [Vector documents](/oss/hokusai/pdf/vector)

## Read next

- [Text, composition & PDF](/oss/hokusai/guide/composition-and-pdf)
- [Encoding & output](/oss/hokusai/encoding-output/)
