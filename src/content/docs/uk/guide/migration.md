---
pageId: guide.migration
translatedFrom: c6cb98f3bf67
title: Міграція з 0.x
---

Hokusai 1.0 замінює адаптерний API версії 0.x незмінними конвеєрами `Hokusai` та асинхронними завершальними операціями виводу.

| Адаптерний API 0.x | Конвеєрний API 1.0 |
| --- | --- |
| `Hokusai.image(from: path)` | `Hokusai(url: URL(fileURLWithPath: path))` |
| `Hokusai.image(from: data)` | `Hokusai(data: data)` |
| `image.resize(...).toFile(path)` | `try await pipeline.resize(...).write(to: URL(...))` |
| `image.crop(...)` | `pipeline.extract(x:y:width:height:)` |
| `image.toBuffer(...)` | Оберіть кодувальник, потім `try await .data()` |

## Правила міграції {#migration-rules}

1. Замініть адаптери завантажених зображень значенням `Hokusai`, створеним із `Data` або файлового `URL`.
2. Будуйте перетворення без `await`; перетворене значення все ще є рецептом.
3. Очікуйте (`await`) лише `data()` і `write(to:)`.
4. Імпортуйте `HokusaiLegacy` лише як тимчасовий міст сумісності.

Оптимізована команда CLI `thumbnail` навмисно зберігає свій застарілий завантажувач мініатюр, доки розробляється публічний аналог мініатюр для конвеєра 1.0.
