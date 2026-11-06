---
pageId: guide.composition-and-pdf
translatedFrom: a4533e0ce295
title: Текст, композиція та PDF
---

Використовуйте конвеєри, щоб накладати зображення шарами та відтворювати локально доступні шрифти через libvips і Pango/Cairo.

## Накладання водяного знака {#compose-a-watermark}

```swift
let base = try Hokusai(url: URL(fileURLWithPath: "photo.jpg"))
let logo = try Hokusai(url: URL(fileURLWithPath: "logo.png"))

let watermarked = try base.composite([
    CompositeLayer(logo, x: 32, y: 32, opacity: 0.8)
])
```

## Відтворення тексту {#render-text}

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

Доступність шрифтів залежить від хост-системи. Постачайте з застосунком потрібні шрифти й вказуйте в `TextOptions` ім'я встановленого шрифту.

## Експорт PDF із зображення {#export-an-image-based-pdf}

```swift
let pdf = try await titled
    .resize(width: 1240)
    .pdf(pageSize: .a4, dpi: 150)
    .write(to: URL(fileURLWithPath: "report.pdf"))
```

PDF-вивід працює на базі Cairo й містить виконаний растровий конвеєр на одній сторінці. Він добре підходить для згенерованих звітів із зображень і багатошарових композицій; виділюваний векторний текст він не зберігає.
