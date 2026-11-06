---
title: Text, Composition & PDF
---

Use pipelines to layer images and render locally available fonts through libvips and Pango/Cairo.

## Compose a watermark

```swift
let base = try Hokusai(url: URL(fileURLWithPath: "photo.jpg"))
let logo = try Hokusai(url: URL(fileURLWithPath: "logo.png"))

let watermarked = try base.composite([
    CompositeLayer(logo, x: 32, y: 32, opacity: 0.8)
])
```

## Render text

```swift
var label = TextOptions(
    font: "sans Bold",
    fontSize: 48,
    color: [255, 255, 255, 255]
)
label.strokeColor = [0, 0, 0, 255]
label.strokeWidth = 2

let titled = try base.drawText(
    "Hello, Hokusai",
    x: 80,
    y: 680,
    options: label
)
```

Font availability depends on the host system. Package any fonts your application requires and use the installed font name in `TextOptions`.

## Export an image-based PDF

```swift
let pdf = try await titled
    .resize(width: 1240)
    .pdf(pageSize: .a4, dpi: 150)
    .write(to: URL(fileURLWithPath: "report.pdf"))
```

PDF output is Cairo-backed and contains the evaluated raster pipeline on one page. It works well for generated image reports and layered compositions; it does not preserve selectable vector text.
