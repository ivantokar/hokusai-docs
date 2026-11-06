---
pageId: reference.operations
translatedFrom: eaad06c0a259
title: Індекс операцій
description: Усі операції Hokusai, згруповані за призначенням.
---

Кожен метод конвеєра `Hokusai`, згрупований за родиною. Сторінка кожної родини перелічує, що роблять її операції; точні сигнатури та значення за замовчуванням містяться в коментарях до вихідного коду бібліотеки.

## Створення {#create}

[Джерела та вхідні дані](/oss/hokusai/uk/sources-input/): `init(data:)`, `init(url:)`, `init(raw:)`, `init(spooling:)`, `text(_:)`.

## Геометрія {#geometry}

[Геометрія](/oss/hokusai/uk/geometry/): `autoOrient()`, `resize(`, `rotate(`, `flip()`, `flop()`, `extract(`, `extend(`, `affine(`, `trim(`, `smartCrop(`.

## Ефекти та колір {#effects-and-color}

[Ефекти та колір](/oss/hokusai/uk/effects-color/): `blur(`, `sharpen(`, `grayscale()`, `tint(`, `normalize(`, `clahe(`, `gamma(`, `negate(`, `median(`, `convolve(`, `linear(`, `recombine(`, `dilate(`, `erode(`, `edges(`, `threshold(`, `modulate(`, `convert(`.

## Канали та прозорість {#channels-and-transparency}

[Канали та прозорість](/oss/hokusai/uk/channels-transparency/): `extractChannel(`, `withAlpha(`, `ensureAlpha(`, `flatten(`, `removeAlpha()`.

## Текст і композиція {#text-and-composition}

[Текст і композиція](/oss/hokusai/uk/text-composition/): `composite(`, `drawText(`, `text(`.

## Кодувальники та вивід {#encoders-and-output}

[Кодування та вивід](/oss/hokusai/uk/encoding-output/): `encode(`, `jpeg(`, `png(`, `webp(`, `avif(`, `heif(`, `tiff(`, `gif(`, `pdf(` (див. [PDF](/oss/hokusai/uk/pdf/)), `metadataPolicy(`, `data()`, `write(`, `writeChunks(`, `raw(`.

## Перевірка зображень {#inspection}

[Перевірка зображень](/oss/hokusai/uk/inspection/): `metadata()`.

## Середовище {#runtime}

[Середовище та продуктивність](/oss/hokusai/uk/runtime-performance/): `initialize()`, `configure(`, `capabilities()`.
