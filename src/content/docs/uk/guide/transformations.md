---
pageId: guide.transformations
translatedFrom: "04f74e1a1c94"
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

Зміна розміру підтримує режим вписування `fit` (`inside`, `outside`, `fill`, `cover`, `contain`), позицію обрізання `position`, ядро `kernel`, тло `background` та керування збільшенням і зменшенням. Викликайте `autoOrient()` ближче до початку рецепта, щоб враховувати орієнтацію EXIF.

## Геометрія та вигляд {#geometry-and-appearance}

```swift
let prepared = try image
    .autoOrient()
    .rotate(by: 90)
    .blur(sigma: 2.5)
    .sharpen()
    .flatten(background: .white)
```

Операції геометрії: `resize`, `extract`, `extend`, `rotate`, `flip`, `flop`, `affine`, `trim` і `smartCrop`. Операції зовнішнього вигляду: `blur`, `sharpen`, `grayscale`, `tint`, `normalize`, `clahe`, `gamma`, `modulate` та інші; дивіться [Геометрія](/oss/hokusai/uk/geometry/), [Ефекти та колір](/oss/hokusai/uk/effects-color/) і [Канали та прозорість](/oss/hokusai/uk/channels-transparency/).

## Кодування результату {#encode-the-result}

```swift
let webp = try await prepared.webp(quality: 82).data()
let avif = try await prepared.avif(quality: 50).data()
```

Обирайте кодувальник виводу наприкінці рецепта. Підтримувані формати виводу дивіться в розділі [Формати та сумісність](/oss/hokusai/uk/reference/formats-and-compatibility).
