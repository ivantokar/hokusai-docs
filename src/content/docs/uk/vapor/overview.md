---
pageId: vapor.overview
translatedFrom: "5474564f8ae3"
title: Hokusai Vapor
---

Hokusai Vapor поєднує конвеєри Hokusai 2 із Vapor 4. Декодуйте завантажене зображення, складіть рецепт і поверніть потокову відповідь із зображенням або PDF.

## Встановлення {#install}

```swift
dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
    .package(url: "https://github.com/ivantokar/hokusai-vapor.git", from: "2.0.0")
]
```

Додайте `HokusaiVapor` до цілі, що визначає ваші маршрути. Нативні вимоги Hokusai не змінюються: на хості потрібні libvips 8.16+, Cairo з підтримкою PDF і `pkg-config`.

## Одноразове налаштування {#configure-once}

```swift
import Vapor
import HokusaiVapor

func configure(_ app: Application) throws {
    try app.hokusai.configure()
    try routes(app)
}
```

`configure()` приймає необов'язковий `RuntimeConfiguration`, що фіксує налаштування рівня процесу до першого зображення, наприклад `.init(maxConcurrentEvaluations: .fixed(4), maxQueuedEvaluations: 64)`. Без нього діють значення за замовчуванням, а нативне середовище запускається під час першого використання. `app.hokusai.capabilities()` і `app.hokusai.runtimeStatus` повідомляють про стан середовища. Не додавайте хук завершення роботи в життєвий цикл Vapor.

## Перший маршрут {#first-route}

```swift
app.post("resize") { req async throws -> Response in
    try await req.hokusaiImage()
        .resize(width: 800, height: 600, fit: .cover)
        .jpeg(quality: 85)
        .response()
}
```

```bash
curl -X POST http://localhost:8080/resize \
  --data-binary "@photo.jpg" \
  -o output.jpg
```

Про необроблені тіла запитів, multipart-файли, PDF-вивід та необов'язкові приклади маршрутів читайте далі в розділі [завантаження та відповіді](/oss/hokusai/uk/vapor/uploads-and-responses).
