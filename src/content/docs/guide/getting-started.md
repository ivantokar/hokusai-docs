---
title: Getting Started
---

Hokusai turns a source image into an immutable processing pipeline. Configure the recipe synchronously, then use an asynchronous terminal to evaluate it.

## Install the package

Add Hokusai to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ivantokar/hokusai.git", from: "1.0.0")
]
```

Add `Hokusai` to the target that processes images. For complete platform setup, see [Installation & Requirements](/oss/hokusai/guide/installation).

## Build and write a pipeline

```swift
import Hokusai

let output = try await Hokusai(url: URL(fileURLWithPath: "photo.jpg"))
    .autoOrient()
    .resize(width: 1200, height: 630, fit: .cover, position: .attention)
    .webp(quality: 82)
    .write(to: URL(fileURLWithPath: "social-card.webp"))

print("Wrote \(output.width) × \(output.height)")
```

`resize`, `webp`, and every other transform returns a new pipeline. Native work runs only when `write(to:)` or `data()` is called.

## Work with upload data

Use a `Data` input when an image already arrived in memory:

```swift
let image = try Hokusai(data: uploadData)
let jpeg = try await image
    .resize(width: 800, height: 600, fit: .cover)
    .jpeg(quality: 85)
    .data()
```

The output contains the encoded bytes and image information. For HTTP request helpers and responses, continue to the [Vapor integration](/oss/hokusai/vapor/overview).

## Next steps

- [Learn how pipelines branch safely](/oss/hokusai/guide/pipelines)
- [Explore transformations](/oss/hokusai/guide/transformations)
- [Add text, composites, or PDF output](/oss/hokusai/guide/composition-and-pdf)
