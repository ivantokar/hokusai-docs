---
pageId: vapor.overview
translatedFrom: a7669e91dee3
title: Hokusai Vapor
---

Hokusai Vapor поєднує конвеєри Hokusai 1.0 із Vapor 4. Декодуйте завантажене зображення, складіть рецепт і поверніть асинхронну відповідь із зображенням або PDF.

## Встановлення {#install}

```swift
dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
    .package(url: "https://github.com/ivantokar/hokusai-vapor.git", from: "1.0.0")
]
```

Додайте `HokusaiVapor` до цілі, що визначає ваші маршрути. Нативні вимоги Hokusai не змінюються: установіть на хості libvips, Cairo і `pkg-config`.

## Одноразове налаштування {#configure-once}

```swift
import Vapor
import HokusaiVapor

func configure(_ app: Application) throws {
    try app.hokusai.configure()
    try routes(app)
}
```

`configure()` ініціалізує нативне середовище обробки зображень Hokusai. Не додавайте хук завершення роботи в життєвий цикл Vapor; звичайне завершення процесу Hokusai обробляє безпечно.

## Перший маршрут {#first-route}

```swift
app.post("resize") { req async throws -> Response in
    let image = try req.hokusaiImage()
    let resized = try image.resize(width: 800, height: 600, fit: .cover)
    return try await resized.response(format: "jpeg", quality: 85)
}
```

```bash
curl -X POST http://localhost:8080/resize \
  --data-binary "@photo.jpg" \
  -o output.jpg
```

Про необроблені тіла запитів, multipart-файли, PDF-вивід та необов'язкові приклади маршрутів читайте далі в розділі [завантаження та відповіді](/oss/hokusai/uk/vapor/uploads-and-responses).
