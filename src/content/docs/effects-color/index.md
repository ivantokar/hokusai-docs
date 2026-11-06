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

## Guides {#guides}

- [Blur & sharpen](/oss/hokusai/effects-color/blur-sharpen)
- [Tone & color](/oss/hokusai/effects-color/tone-and-color)
- [Filters](/oss/hokusai/effects-color/filters)

## Read next

- [Channels & transparency](/oss/hokusai/channels-transparency/)
- [Operation index](/oss/hokusai/reference/operations)
