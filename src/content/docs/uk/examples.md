---
pageId: examples
translatedFrom: 33a668a11ec2
title: Приклади
---

## Створення соціальної картки {#create-a-social-card}

```swift
let card = try await Hokusai(url: URL(fileURLWithPath: "photo.jpg"))
    .autoOrient()
    .resize(width: 1200, height: 630, fit: .cover, position: .attention)
    .webp(quality: 82)
    .write(to: URL(fileURLWithPath: "social-card.webp"))
```

## Додавання водяного знака {#add-a-watermark}

```swift
let base = try Hokusai(url: URL(fileURLWithPath: "photo.jpg"))
let mark = try Hokusai(url: URL(fileURLWithPath: "logo.png"))

let output = try await base
    .composite([CompositeLayer(mark, x: 32, y: 32, opacity: 0.8)])
    .jpeg(quality: 88)
    .write(to: URL(fileURLWithPath: "watermarked.jpg"))
```

## Експорт PDF-звіту із зображення {#export-an-image-report-pdf}

```swift
let report = try await Hokusai(url: URL(fileURLWithPath: "chart.png"))
    .resize(width: 1240)
    .pdf(pageSize: .a4, dpi: 150)
    .write(to: URL(fileURLWithPath: "report.pdf"))
```

## Повернення зображення з Vapor {#return-an-image-from-vapor}

```swift
app.post("resize") { req async throws -> Response in
    let image = try req.hokusaiImage()
    let resized = try image.resize(width: 800, height: 600, fit: .cover)
    return try await resized.response(format: "webp", quality: 82)
}
```

Повне налаштування дивіться в [Hokusai Vapor](/oss/hokusai/uk/vapor/overview).
