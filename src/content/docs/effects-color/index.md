---
pageId: effects-color.index
title: Effects & color
description: Filters, tone and color operations.
---

| Operation | What it does |
| --- | --- |
| `blur(sigma:precision:minAmplitude:)` | Gaussian blur. |
| `sharpen(sigma:)`, `sharpen(_:)` | Sharpening, with `SharpenOptions` for fine control. |
| `grayscale()`, `tint(_:)` | Remove colour, or map luminance onto a colour. |
| `normalize(lower:upper:)`, `clahe(width:height:maxSlope:)` | Stretch contrast, globally or locally. |
| `gamma(_:)`, `modulate(brightness:saturation:hue:)`, `negate(alpha:)`, `threshold(_:grayscale:)` | Tone and colour adjustments. |
| `median(size:)` | Median filter. |
| `convolve(_:)`, `linear(multiply:add:)`, `recombine(_:)` | Kernel, linear and channel-matrix transforms. |
| `dilate(radius:)`, `erode(radius:)`, `edges(_:)` | Morphology and edge detection (`sobel`, `scharr`, `prewitt`, `canny`). |
| `convert(to:)` | Converts to `sRGB` or `grayscale`. |

:::note[Detailed guides are in progress]
This page lists what Hokusai provides in the documented release. Operation-by-operation guides with parameters, defaults, visual results and interactions are being added; the precise API contract is in the source comments of the library.
:::

## Read next

- [Channels & transparency](/oss/hokusai/channels-transparency/)
- [Operation index](/oss/hokusai/reference/operations)
