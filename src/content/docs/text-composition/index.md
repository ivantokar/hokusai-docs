---
pageId: text-composition.index
title: Text & composition
description: Generated text, layers and blending.
---

| Operation | What it does |
| --- | --- |
| ``Hokusai.text(_:layout:style:)` | Renders text as a new pipeline with a `TextStyle` (font, size, colour, alignment, stroke, shadow, rotation). |
| `drawText(_:placement:layout:style:)` | Draws text onto a pipeline; sugar for compositing it. |
| `composite(_:space:)` | Blends `CompositeLayer`s (`placement`, `blend`, `opacity`) in `srgb` or `linear` space. |

Text can be plain or Pango markup, laid out naturally, wrapped to a width or fitted to a box. Text rendering needs a libvips built with Pango; fonts come from the host.

:::note[Detailed guides are in progress]
This page lists what Hokusai provides in the documented release. Operation-by-operation guides with parameters, defaults, visual results and interactions are being added; the precise API contract is in the source comments of the library.
:::

## Read next

- [Text, composition & PDF](/oss/hokusai/guide/composition-and-pdf)
- [Examples](/oss/hokusai/examples)
