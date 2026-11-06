---
pageId: guide.transformations
title: Transformations
---

Hokusai provides typed image operations that can be freely composed into a single pipeline.

## Resize and crop

```swift
let cover = try image.resize(
    width: 1200,
    height: 630,
    fit: .cover,
    position: .attention
)

let region = try image.extract(x: 100, y: 80, width: 640, height: 480)
```

Resize supports fit, crop position, kernel, background, and enlargement/reduction controls. Use `autoOrient()` near the start of a recipe to respect EXIF orientation.

## Geometry and appearance

```swift
let prepared = try image
    .autoOrient()
    .rotate(.d90)
    .blur(sigma: 2.5)
    .sharpen()
    .flatten(background: .white)
```

Core operations include resizing, extraction, rotation, blur, sharpen, trim, tint, alpha removal, flattening, and metadata inspection.

## Encode the result

```swift
let webp = try await prepared.webp(quality: 82).data()
let avif = try await prepared.avif(quality: 50).data()
```

Choose the output encoder late in the recipe. See [Formats & Compatibility](/oss/hokusai/reference/formats-and-compatibility) for supported output formats and the v1 migration notes.
