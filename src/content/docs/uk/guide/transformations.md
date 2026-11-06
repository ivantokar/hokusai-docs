---
pageId: guide.transformations
translatedFrom: 5970a5ffc99a
title: Перетворення
---

Hokusai надає типізовані операції над зображеннями, які можна вільно поєднувати в одному конвеєрі.

## Зміна розміру та обрізання {#resize-and-crop}

```swift
let cover = try image.resize(
    width: 1200,
    height: 630,
    fit: .cover,
    position: .attention
)

let region = try image.extract(x: 100, y: 80, width: 640, height: 480)
```

Зміна розміру підтримує режим вписування, позицію обрізання, ядро, тло та керування збільшенням і зменшенням. Викликайте `autoOrient()` ближче до початку рецепта, щоб враховувати орієнтацію EXIF.

## Геометрія та вигляд {#geometry-and-appearance}

```swift
let prepared = try image
    .autoOrient()
    .rotate(.d90)
    .blur(sigma: 2.5)
    .sharpen()
    .flatten(background: .white)
```

Основні операції: зміна розміру, виділення ділянки, обертання, розмиття, підвищення різкості, обрізання полів, тонування, вилучення альфа-каналу, згладжування на тло та перегляд метаданих.

## Кодування результату {#encode-the-result}

```swift
let webp = try await prepared.webp(quality: 82).data()
let avif = try await prepared.avif(quality: 50).data()
```

Обирайте кодувальник виводу наприкінці рецепта. Підтримувані формати виводу та примітки щодо міграції на v1 дивіться в розділі [Формати та сумісність](/oss/hokusai/uk/reference/formats-and-compatibility).
