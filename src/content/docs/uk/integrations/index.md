---
pageId: integrations.index
translatedFrom: "e82389f57f24"
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

Виконувані демо є в [hokusai-examples](https://github.com/ivantokar/hokusai-examples) ([як їх запускати, тестувати й переносити](/oss/hokusai/uk/integrations/examples)): одна вебпісочниця, яку віддають бекенд на Vapor і бекенд на Hummingbird, та нативна пісочниця для macOS; усі вони генерують Swift-код, що відтворює зібране. Ці сторінки від них не залежать: кожен фрагмент тут виконується або компілюється цим репозиторієм.

## Посібники {#guides}

- [Буфери SwiftNIO](/oss/hokusai/uk/integrations/nio)
- [Vapor: повний сервіс](/oss/hokusai/uk/integrations/vapor-service)
- [Hokusai Hummingbird](/oss/hokusai/uk/integrations/hummingbird)
- [macOS](/oss/hokusai/uk/integrations/macos)
- [Docker](/oss/hokusai/uk/integrations/docker)
- [Приклади: запуск, тестування й перенесення демо](/oss/hokusai/uk/integrations/examples)

## Читайте далі {#read-next}

- [Завантаження та відповіді](/oss/hokusai/uk/vapor/uploads-and-responses)
