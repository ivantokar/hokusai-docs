---
pageId: inspection.index
translatedFrom: "68656972865c"
title: Перевірка зображень
description: Як прочитати, що містить джерело.
---

`metadata()` є `async` і повідомляє те, що кореневе джерело сказало під час відкриття; він ніколи не описує перетворений конвеєр. Він читає лише заголовок.

`ImageMetadata` містить формат, збережений і орієнтований розмір, `orientation`, `PixelMetadata` (канали, альфа, інтерпретація, формат вибірки), `PageMetadata`, необов'язковий `AnimationMetadata`, `ImageDensity` та вбудовані блоки EXIF, ICC, XMP та IPTC. Те, що дасть конвеєр, описує натомість `OutputInfo`.

У командному рядку використовуйте `hokusai inspect` (`--json` для скриптів).

## Посібники {#guides}

- [Читання метаданих](/oss/hokusai/uk/inspection/metadata)

## Читайте далі {#read-next}

- [Джерела та вхідні дані](/oss/hokusai/uk/sources-input/)
- [Довідник CLI](/oss/hokusai/uk/reference/cli)
