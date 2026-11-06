---
pageId: vapor.uploads-and-responses
translatedFrom: c48027ede125
title: Завантаження та відповіді
---

Hokusai Vapor завантажує запит у звичайний незмінний конвеєр `Hokusai`. Перетворюйте його так само, як у будь-якому застосунку Swift, а потім очікуйте типізовану HTTP-відповідь.

## Необроблене тіло запиту {#raw-request-body}

```swift
app.post("resize") { req async throws -> Response in
    let image = try req.hokusaiImage()
    let resized = try image.resize(width: 800, height: 600, fit: .cover)
    return try await resized.response(format: "jpeg", quality: 85)
}
```

Тіло запиту має містити закодовані байти зображення. Відсутнє або нечитабельне тіло повертає `400 Bad Request`.

## Multipart-завантаження {#multipart-upload}

```swift
app.post("upload") { req async throws -> Response in
    let image = try req.hokusaiImage(field: "image")
    let thumbnail = try image.resize(width: 200, height: 200, fit: .cover)
    return try await thumbnail.response(format: "png", compression: 6)
}
```

Ім'я поля має збігатися з файловим полем multipart. Відсутні поля та нечитабельні дані файлу повертають `400 Bad Request`.

## Формати виводу {#output-formats}

`response` асинхронно виконує конвеєр і встановлює відповідний заголовок `Content-Type`:

```swift
try await image.response(format: "jpeg", quality: 85)
try await image.response(format: "png", compression: 6)
try await image.response(format: "webp", quality: 82)
try await image.response(format: "avif", quality: 50)
try await image.response(format: "pdf")
```

Відповіді PDF — це односторінкові растрові документи на базі Cairo. Вони підходять для згенерованих звітів із зображень і багатошарових композицій, але не зберігають виділюваний векторний текст.

## Необов'язкові приклади маршрутів {#optional-example-routes}

Зареєструйте `ImageProcessingRoutes` для простих прикладів із необробленим тілом:

```swift
try ImageProcessingRoutes.register(to: app.grouped("api", "images"))
```

- `POST /api/images/text?text=Hello&fontSize=48`
- `POST /api/images/convert?format=webp&quality=82`

Обидва приймають вихідне зображення як необроблене тіло запиту.
