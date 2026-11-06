---
pageId: vapor.uploads-and-responses
translatedFrom: 85e2a059a5c3
title: Завантаження та відповіді
---

Hokusai Vapor завантажує запит у звичайний незмінний конвеєр `Hokusai`. Перетворюйте його так само, як у будь-якому застосунку Swift, оберіть кодувальник і поверніть потокову HTTP-відповідь.

## Необроблене тіло запиту {#raw-request-body}

```swift
app.post("resize") { req async throws -> Response in
    try await req.hokusaiImage()
        .resize(width: 800, height: 600, fit: .cover)
        .jpeg(quality: 85)
        .response()
}
```

Тіло запиту має містити закодовані байти зображення. Тіло читається в міру надходження й ніколи не понад `maximumSize` (за замовчуванням 20 МіБ): оголошений `Content-Length` понад ліміт відхиляється до читання будь-якого байта, а тіло без нього відхиляється, щойно перевищить ліміт, обидва випадки дають `413`. Невелике завантаження лишається в пам'яті; більше за `memoryLimit` (за замовчуванням 1 МіБ) переходить у приватний тимчасовий файл. Відсутнє або нечитабельне тіло повертає `400 Bad Request`.

## Multipart-завантаження {#multipart-upload}

```swift
app.post("upload") { req async throws -> Response in
    try await req.hokusaiImage(field: "image")
        .resize(width: 200, height: 200, fit: .cover)
        .png()
        .response()
}
```

Ім'я поля має збігатися з файловим полем multipart. Відсутні поля та нечитабельні дані файлу повертають `400 Bad Request`.

## Формати виводу {#output-formats}

Оберіть кодувальник на конвеєрі, потім викличте `response()`. `Content-Type` береться з формату, який дає кодувальник, а тіло записується в міру кодування, тож повільний клієнт сповільнює кодування замість того, щоб збільшувати пам'ять:

```swift
try await image.jpeg(quality: 85).response()
try await image.png().response()
try await image.webp(quality: 82).response(headers: ["Cache-Control": "public, max-age=3600"])
try await image.avif(quality: 50).response()
try await image.pdf().response()
```

Відповіді PDF — це односторінкові растрові документи на базі Cairo. Вони підходять для згенерованих звітів із зображень і багатошарових композицій, але не зберігають виділюваний векторний текст.

## Необов'язкові приклади маршрутів {#optional-example-routes}

Зареєструйте `ImageProcessingRoutes` для простих прикладів із необробленим тілом:

```swift
try ImageProcessingRoutes.register(to: app.grouped("api", "images"))
```

- `POST /api/images/text?text=Hello&fontSize=48` (також `font`, `strokeWidth`, `quality`)
- `POST /api/images/convert?format=webp&quality=82` (також `compression`)

Обидва приймають вихідне зображення як необроблене тіло запиту.

## Помилки {#errors}

`HokusaiError` відображається на статус за своїм випадком: `invalidInput` і `invalidOption` дають 400, `decode` — 422, `resource` — 413 для байтів, 422 для пікселів або каналів і 503 для черги обчислень, `unsupported` — 501, а `io`, `transform`, `encode` і `runtime` — 500. `response()` і `hokusaiImage` уже застосовують це відображення; для маршруту, що сам виконує конвеєр через `data()` або `write(to:)`, додайте `HokusaiErrorMiddleware()`.
