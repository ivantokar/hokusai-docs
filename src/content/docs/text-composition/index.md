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

## Guides {#guides}

- [Generated text](/oss/hokusai/text-composition/text)
- [Composition](/oss/hokusai/text-composition/composite)

## Read next

- [Text, composition & PDF](/oss/hokusai/guide/composition-and-pdf)
- [Examples](/oss/hokusai/examples)
