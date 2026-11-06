---
pageId: guide.composition-and-pdf
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
let label = TextStyle(
    font: "sans Bold",
    fontSize: 48,
    color: .white,
    stroke: TextStroke(color: Color(red: 0, green: 0, blue: 0), width: 2)
)

let titled = try base.drawText(
    "Hello, Hokusai",
    placement: .at(x: 80, y: 680),
    style: label
)
```

Font availability depends on the host system. Package any fonts your application requires and use the installed font name in `TextStyle`.

## Export an image-based PDF

```swift
let pdf = try await titled
    .resize(width: 1240)
    .pdf(pageSize: .a4)
    .write(to: URL(fileURLWithPath: "report.pdf"))
```

PDF output is Cairo-backed and contains the evaluated raster pipeline on one page. It works well for generated image reports and layered compositions; it does not preserve selectable vector text. For vector documents with real, selectable text, use the `HokusaiPDF` product (see [PDF](/oss/hokusai/pdf/)).
