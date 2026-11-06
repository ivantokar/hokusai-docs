---
pageId: geometry.index
title: Geometry
description: Resizing, cropping, rotating and reshaping the pixel grid.
---

| Operation | What it does |
| --- | --- |
| `autoOrient()` | Applies the source EXIF orientation. |
| `resize(width:height:fit:position:kernel:withoutEnlargement:withoutReduction:background:)` | Resizes with `fit` (`inside`, `outside`, `fill`, `cover`, `contain`) and a crop `position`. |
| `rotate(by:background:interpolation:)` | Rotates clockwise by degrees; right angles are lossless. |
| `flip()`, `flop()` | Mirror vertically and horizontally. |
| `extract(x:y:width:height:)` | Crops a rectangle. |
| `extend(to:anchor:background:)`, `extend(to:anchor:mode:)`, `extend(top:left:bottom:right:mode:)` | Adds canvas, filled with a colour, a copy, a repeat or a mirror. |
| `affine(_:inputOffset:outputOffset:outputArea:edges:interpolation:)` | Applies an affine matrix. |
| `trim(threshold:)`, `trim(_:)` | Removes a uniform border. |
| `smartCrop(width:height:strategy:)` | Crops to the most interesting region (`attention` or `entropy`). |

## Guides {#guides}

- [Resize](/oss/hokusai/geometry/resize)
- [Crop & canvas](/oss/hokusai/geometry/crop-and-canvas)
- [Rotate, flip & affine](/oss/hokusai/geometry/rotate-flip-affine)

## Read next

- [Transformations](/oss/hokusai/guide/transformations)
- [Operation index](/oss/hokusai/reference/operations)
