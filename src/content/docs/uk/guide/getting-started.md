---
pageId: guide.getting-started
translatedFrom: 6734e0be50f3
title: Початок роботи
---

Hokusai перетворює вихідне зображення на незмінний конвеєр обробки. Налаштуйте рецепт синхронно, а потім виконайте його асинхронною завершальною операцією.

## Встановлення пакета {#install-the-package}

Додайте Hokusai до `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ivantokar/hokusai.git", from: "2.0.0")
]
```

Додайте `Hokusai` до цілі, яка обробляє зображення. Повне налаштування платформи дивіться в розділі [Встановлення та вимоги](/oss/hokusai/uk/guide/installation).

## Побудова й запис конвеєра {#build-and-write-a-pipeline}

```swift
import Hokusai

let output = try await Hokusai(url: URL(fileURLWithPath: "photo.jpg"))
    .autoOrient()
    .resize(width: 1200, height: 630, fit: .cover, position: .attention)
    .webp(quality: 82)
    .write(to: URL(fileURLWithPath: "social-card.webp"))

print("Wrote \(output.width) × \(output.height)")
```

`resize`, `webp` та кожне інше перетворення повертають новий конвеєр. Нативна робота виконується лише під час виклику `write(to:)` або `data()`.

## Робота із завантаженими даними {#work-with-upload-data}

Використовуйте вхід `Data`, коли зображення вже надійшло в пам'ять:

```swift
let image = try Hokusai(data: uploadData)
let jpeg = try await image
    .resize(width: 800, height: 600, fit: .cover)
    .jpeg(quality: 85)
    .data()
```

Вивід містить закодовані байти та відомості про зображення. Про допоміжні засоби HTTP-запитів і відповідей читайте далі в [інтеграції з Vapor](/oss/hokusai/uk/vapor/overview).

## Наступні кроки {#next-steps}

- [Як безпечно розгалужувати конвеєри](/oss/hokusai/uk/guide/pipelines)
- [Огляд перетворень](/oss/hokusai/uk/guide/transformations)
- [Додавання тексту, композитів і PDF-виводу](/oss/hokusai/uk/guide/composition-and-pdf)
