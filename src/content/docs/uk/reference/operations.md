---
pageId: reference.operations
translatedFrom: "1516b177c994"
title: Індекс операцій
description: Усі операції Hokusai, згруповані за призначенням.
---

Кожен метод конвеєра `Hokusai`, згрупований за родиною. Сторінка кожної родини перелічує, що роблять її операції; точні сигнатури та значення за замовчуванням містяться в коментарях до вихідного коду бібліотеки.

## Створення {#create}

Посібники: [Параметри входу](/oss/hokusai/uk/sources-input/input-options), [Необроблені пікселі](/oss/hokusai/uk/sources-input/raw-pixels), [Великі завантаження](/oss/hokusai/uk/sources-input/uploads), [Згенерований текст](/oss/hokusai/uk/text-composition/text).

[Джерела та вхідні дані](/oss/hokusai/uk/sources-input/): `init(data:)`, `init(url:)`, `init(raw:)`, `init(spooling:)`, `text(_:)`.

## Геометрія {#geometry}

Посібники: [Зміна розміру](/oss/hokusai/uk/geometry/resize), [Обрізання та полотно](/oss/hokusai/uk/geometry/crop-and-canvas), [Обертання, віддзеркалення та афінні перетворення](/oss/hokusai/uk/geometry/rotate-flip-affine).

[Геометрія](/oss/hokusai/uk/geometry/): `autoOrient()`, `resize(`, `rotate(`, `flip()`, `flop()`, `extract(`, `extend(`, `affine(`, `trim(`, `smartCrop(`.

## Ефекти та колір {#effects-and-color}

Посібники: [Розмиття та різкість](/oss/hokusai/uk/effects-color/blur-sharpen), [Тон і колір](/oss/hokusai/uk/effects-color/tone-and-color), [Фільтри](/oss/hokusai/uk/effects-color/filters).

[Ефекти та колір](/oss/hokusai/uk/effects-color/): `blur(`, `sharpen(`, `grayscale()`, `tint(`, `normalize(`, `clahe(`, `gamma(`, `negate(`, `median(`, `convolve(`, `linear(`, `recombine(`, `dilate(`, `erode(`, `edges(`, `threshold(`, `modulate(`, `convert(`.

## Канали та прозорість {#channels-and-transparency}

Посібник: [Канали та альфа](/oss/hokusai/uk/channels-transparency/alpha-and-channels).

[Канали та прозорість](/oss/hokusai/uk/channels-transparency/): `extractChannel(`, `withAlpha(`, `ensureAlpha(`, `flatten(`, `removeAlpha()`.

## Текст і композиція {#text-and-composition}

Посібники: [Згенерований текст](/oss/hokusai/uk/text-composition/text), [Композиція](/oss/hokusai/uk/text-composition/composite).

[Текст і композиція](/oss/hokusai/uk/text-composition/): `composite(`, `drawText(`, `text(`.

## Кодувальники та вивід {#encoders-and-output}

Посібники: [Кодувальники](/oss/hokusai/uk/encoding-output/formats), [Завершальні операції виводу](/oss/hokusai/uk/encoding-output/terminals), [Збереження метаданих](/oss/hokusai/uk/encoding-output/metadata), [Растровий PDF](/oss/hokusai/uk/pdf/raster), [Векторні документи](/oss/hokusai/uk/pdf/vector).

[Кодування та вивід](/oss/hokusai/uk/encoding-output/): `encode(`, `jpeg(`, `png(`, `webp(`, `avif(`, `heif(`, `tiff(`, `gif(`, `pdf(` (див. [PDF](/oss/hokusai/uk/pdf/)), `metadataPolicy(`, `data()`, `write(`, `writeChunks(`, `raw(`.

## Перевірка зображень {#inspection}

Посібник: [Читання метаданих](/oss/hokusai/uk/inspection/metadata).

[Перевірка зображень](/oss/hokusai/uk/inspection/): `metadata()`.

## Середовище {#runtime}

Посібники: [Конфігурація середовища виконання](/oss/hokusai/uk/runtime-performance/runtime), [Продуктивність](/oss/hokusai/uk/runtime-performance/performance).

[Середовище та продуктивність](/oss/hokusai/uk/runtime-performance/): `initialize()`, `configure(`, `capabilities()`.
