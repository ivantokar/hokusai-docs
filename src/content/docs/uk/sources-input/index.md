---
pageId: sources-input.index
translatedFrom: "95e1bc337726"
title: Джерела та вхідні дані
description: Усі способи створити конвеєр Hokusai.
---

| Створити конвеєр із | API | Модуль |
| --- | --- | --- |
| Закодованих байтів | `Hokusai(data:options:)` | Hokusai |
| Файлу | `Hokusai(url:options:)` | Hokusai |
| Необроблених пікселів, які ви вже маєте | `Hokusai(raw:width:height:format:rowStride:premultiplied:limits:)`, `Hokusai(raw: RawImage)` | Hokusai |
| Завантаження, що надходить частинами | `Hokusai(spooling:options:memoryLimit:spoolDirectory:)` | Hokusai |
| Буферів NIO | `Hokusai(buffer:options:byteTransferStrategy:)`, `Hokusai(spooling:)` з `ByteBuffer` | HokusaiNIO |
| Згенерованого тексту | `Hokusai.text(_:layout:style:)` | Hokusai |

`InputOptions` обирає `page` багатосторінкового джерела, режим доступу `access` (`random` або `sequential`), рівень помилки декодування `failOn` та `limits`. `InputLimits` обмежує `maxBytes`, `maxPixels` і `maxChannels` до будь-якої нативної роботи. Формати необроблених пікселів: `gray8`, `grayAlpha8`, `rgb8`, `rgba8` та їхні 16-бітні варіанти.

## Посібники {#guides}

- [Параметри входу та ліміти](/oss/hokusai/uk/sources-input/input-options)
- [Необроблені пікселі](/oss/hokusai/uk/sources-input/raw-pixels)
- [Великі завантаження](/oss/hokusai/uk/sources-input/uploads)

## Читайте далі {#read-next}

- [Конвеєри та конкурентність](/oss/hokusai/uk/guide/pipelines)
- [Перевірка зображень](/oss/hokusai/uk/inspection/)
