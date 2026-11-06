---
pageId: encoding-output.index
translatedFrom: 4f36182ec6f0
title: Кодування та вивід
description: Кодувальники, завершальні операції та збереження метаданих.
---

**Кодувальники** обирають формат виводу: `jpeg`, `png`, `webp`, `avif`, `heif`, `tiff`, `gif` і `pdf`, кожен із короткою формою та формою `options:` (`JPEGOptions`, `PNGOptions`, `WebPOptions`, `AVIFOptions`, `HEIFOptions`, `TIFFOptions`, `GIFOptions`).

**Завершальні операції** дають результат: `data()` повертає байти `Output` та `OutputInfo`, `write(to:)` атомарно записує файл, `writeChunks(chunkSize:_:)` передає потоком, `raw(_:premultiplied:background:)` повертає необроблені пікселі. `HokusaiNIO` додає `byteBuffer()` і `writeByteBuffers`.

**Метадані**, що зберігаються у виводі, — це типізована `MetadataPolicy`, яку застосовує `metadataPolicy(_:)`. За замовчуванням EXIF, XMP, IPTC і коментарі вилучаються, а профіль ICC, орієнтація та щільність зберігаються.

Що встановлена libvips може читати й записувати, повідомляє `Hokusai.capabilities()`.

:::note[Докладні посібники в розробці]
На цій сторінці перелічено, що надає Hokusai у задокументованому релізі. Посібники з кожної операції, з параметрами, значеннями за замовчуванням, візуальними результатами та взаємодіями, додаються; точний контракт API міститься в коментарях до вихідного коду бібліотеки.
:::

## Читайте далі {#read-next}

- [Формати та сумісність](/oss/hokusai/uk/reference/formats-and-compatibility)
- [PDF](/oss/hokusai/uk/pdf/)
