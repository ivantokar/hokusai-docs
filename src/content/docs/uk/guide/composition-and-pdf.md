---
pageId: guide.composition-and-pdf
translatedFrom: "9feb11d5d2e6"
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

Доступність шрифтів залежить від хост-системи. Постачайте з застосунком потрібні шрифти й вказуйте в `TextStyle` ім'я встановленого шрифту.

## Експорт PDF із зображення {#export-an-image-based-pdf}

```swift
let pdf = try await titled
    .resize(width: 1240)
    .pdf(pageSize: .a4)
    .write(to: URL(fileURLWithPath: "report.pdf"))
```

PDF-вивід працює на базі Cairo й містить виконаний растровий конвеєр на одній сторінці. Він добре підходить для згенерованих звітів із зображень і багатошарових композицій; виділюваний векторний текст він не зберігає. Для векторних документів зі справжнім виділюваним текстом використовуйте продукт `HokusaiPDF` (див. [PDF](/oss/hokusai/uk/pdf/)).
