---
pageId: reference.cli
translatedFrom: 0d0cff934d51
title: Довідник CLI
---

Офіційний виконуваний файл `hokusai` перевіряє, перетворює й тестує продуктивність локальних зображень. Він входить до пакета Hokusai і є тонким клієнтом публічного API `Hokusai`.

## Запуск конвеєра {#run-a-pipeline}

`hokusai run` — це конвеєр, записаний так, як його пише бібліотека: вхід, кроки з іменами методів API в порядку застосування та вивід.

```bash
hokusai run photo.jpg auto-orient resize --width 1200 --height 630 --fit cover \
  blur --sigma 1.5 webp --quality 82 -o social.webp --json

hokusai run --text "Hokusai" --font-size 48 png -o title.png

cat photo.jpg | hokusai run - resize --width 400 jpeg -o - > small.jpg
```

Зображення декодується один раз і кодується один раз, скільки б кроків не було. Вхід — це шлях, `-` для стандартного вводу або `--text` / `--markup` для згенерованого тексту, з параметрами `InputOptions` та `InputLimits`. `-o <path>` записує файл (його розширення обирає кодувальник, якщо крок кодувальника не задано); `-o -` пише у стандартний вивід і потребує кроку кодувальника. `--json` друкує `OutputInfo` запису. Для кожної публічної операції є крок і для кожного кодувальника (`jpeg`, `png`, `webp`, `avif`, `heif`, `tiff`, `gif`, `pdf`), а також `metadata-policy`. Кожен крок приймає параметри свого методу зі значеннями методу за замовчуванням.

```bash
hokusai run --help
hokusai run photo.jpg resize --help
```

## Середовище та метадані {#runtime-and-metadata}

```bash
hokusai --version
hokusai info
hokusai inspect --input photo.jpg
```

`info` показує версії Hokusai, libvips і Cairo та можливості встановленого середовища. `inspect` повідомляє метадані джерела; для скриптів доступний `--json`.

## Застарілі команди {#deprecated-commands}

`resize`, `thumbnail`, `convert`, `rotate`, `crop` і `text` ще працюють, виводять повідомлення про застарілість у стандартний потік помилок і будуть вилучені в наступному мажорному релізі. Використовуйте `hokusai run`. Їхні значення за замовчуванням збігаються з бібліотекою: `resize` вписує з `cover`, а текст має 24 пункти й чорний колір.

## Бенчмарк конвеєра {#benchmark-a-pipeline}

```bash
hokusai benchmark run --help
hokusai benchmark compare --help
```

`benchmark run` перебирає кількість обчислень і паралельність libvips, для кожної комірки запускаючи новий робочий процес, і записує версіонований JSON-результат. `benchmark compare` повідомляє різницю за комірками між двома результатами.
