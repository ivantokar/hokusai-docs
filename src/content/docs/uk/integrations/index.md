---
pageId: integrations.index
translatedFrom: "c17b88ccf297"
title: Інтеграції
description: Hokusai у вебфреймворках і NIO.
---

| Пакет | Версія | Що надає |
| --- | --- | --- |
| [Hokusai Vapor](/oss/hokusai/uk/vapor/overview) | 2.1.0 | `req.hokusaiImage()`, multipart-поля, `response()`, `HokusaiErrorMiddleware`, `app.hokusai` |
| [Hokusai Hummingbird](https://github.com/ivantokar/hokusai-hummingbird) | 2.1.0 | `hokusaiImage()` для запитів, `response()`, `HokusaiErrorMiddleware` |
| `HokusaiNIO` (в основному пакеті) | 2.2.2 | Входи й виходи `ByteBuffer`, потокові буфери |

Адаптери поділяють з основною бібліотекою лише мажорну версію.

## Демонстраційні застосунки {#demos}

Виконуваний демо-застосунок Vapor із вебінтерфейсом є в [hokusai-vapor-example](https://github.com/ivantokar/hokusai-vapor-example); єдиний репозиторій прикладів та веб- і macOS-пісочниці для macOS відстежуються в [hokusai#161–#165](https://github.com/ivantokar/hokusai/issues/161). Ці сторінки від них не залежать: кожен фрагмент тут виконується або компілюється цим репозиторієм.

## Посібники {#guides}

- [Буфери SwiftNIO](/oss/hokusai/uk/integrations/nio)
- [Vapor: повний сервіс](/oss/hokusai/uk/integrations/vapor-service)
- [Hokusai Hummingbird](/oss/hokusai/uk/integrations/hummingbird)
- [macOS](/oss/hokusai/uk/integrations/macos)
- [Docker](/oss/hokusai/uk/integrations/docker)

## Читайте далі {#read-next}

- [Завантаження та відповіді](/oss/hokusai/uk/vapor/uploads-and-responses)
