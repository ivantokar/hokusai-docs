---
pageId: reference.cli
translatedFrom: "144748242020"
title: Довідник CLI
---

Офіційний виконуваний файл `hokusai` перевіряє, перетворює й тестує продуктивність локальних зображень. Він входить до пакета Hokusai (`swift run hokusai` або зібраний архів для macOS arm64, прикріплений до кожного релізу на GitHub) і є тонким клієнтом публічного API `Hokusai`: що б не робив крок, це робить метод з такою самою назвою. Виводи, наведені на цій сторінці, створив Hokusai 2.2.2 на машині документації.

## hokusai run {#run-a-pipeline}

`hokusai run` — це конвеєр, записаний так, як його пише бібліотека: вхід, **кроки з іменами методів API в порядку застосування** та вивід. Зображення декодується один раз і кодується один раз, скільки б кроків не було.

```bash
hokusai run photo.jpg auto-orient resize --width 1200 --height 630 --fit cover \
  blur --sigma 1.5 webp --quality 82 -o social.webp --json

hokusai run --text "Hokusai" --font-size 48 png -o title.png

cat photo.jpg | hokusai run - resize --width 400 jpeg -o - > small.jpg
```

Перша форма на `phone.jpg` (фото з телефона боком) вивела:

```json
{"byteCount":10882,"format":"webp","height":500,"mimeType":"image\/webp","output":"social.webp","width":800}
```

(`--json` друкує `OutputInfo` запису; для PDF додається `pdf` з `pageCount`, `pageWidth`, `pageHeight`.) Коли вивід — `-`, зображення йде у стандартний вивід, а звіт — у стандартний потік помилок.

### Вхід і вивід {#input-output}

- **Вхід** — це шлях, `-` для стандартного вводу або `--text` / `--markup` для згенерованого тексту, з полями `InputOptions` та `InputLimits`: `--page`, `--access`, `--fail-on`, `--max-bytes`, `--max-pixels`, `--max-channels`, `--revalidate`.
- **`-o <path>`** записує файл; його розширення обирає кодувальник, якщо крок кодувальника не задано. **`-o -`** пише у стандартний вивід і потребує кроку кодувальника, бо немає імені, з якого взяти формат.
- Значення, що починається з тире, пишуть зі знаком рівності: `--hue=-30`.
- `-v` / `--verbose` показує нативну діагностику збою.

### Кроки {#steps}

Для кожної публічної операції є крок і для кожного кодувальника. `hokusai run photo.jpg resize --help` друкує параметри одного кроку; кожен приймає параметри методу **зі значеннями методу за замовчуванням**.

| Група | Кроки |
| --- | --- |
| Геометрія | `auto-orient`, `resize`, `rotate`, `flip`, `flop`, `extract`, `extend`, `affine`, `trim`, `smart-crop` |
| Ефекти | `blur`, `sharpen`, `grayscale`, `tint`, `normalize`, `clahe`, `gamma`, `negate`, `median`, `threshold`, `modulate` |
| Розширені фільтри | `convolve`, `linear`, `recombine`, `dilate`, `erode`, `edges`, `extract-channel`, `with-alpha` |
| Колір і альфа | `convert-to`, `ensure-alpha`, `flatten`, `remove-alpha` |
| Композиція й текст | `composite` (повторіть для більшої кількості шарів), `draw-text` |
| Кодувальники виводу | `jpeg`, `png`, `webp`, `avif`, `heif`, `tiff`, `gif`, `pdf` та `metadata-policy` |

Параметри кроків віддзеркалюють API: `resize` приймає `--width`, `--height`, `--fit` (типово `cover`, також `contain`, `fill`, `inside`, `outside`), `--position` (`center`, сторони світу, `attention`, `entropy`), `--kernel` (типово `lanczos3`), `--without-enlargement`, `--without-reduction` та `--background r,g,b[,a]`. Що означають параметри, дивіться на відповідній сторінці кожної родини.

### Помилки й статус виходу {#errors}

Аргументи суворі: невідомі слова fit, kernel, вирівнювання й обрізання та хибні, нескінченні чи позадіапазонні кольори завершуються помилкою, а не підміняються типовим значенням. Перевірка діапазонів — справа Hokusai, а не CLI:

```text
$ hokusai run scene.png resize --width 0 jpeg -o x.jpg
Error: Invalid option 'width': must be in 1...2147483647
$ echo $?
1
```

Невідомий крок відхиляється як несподіваний аргумент. Повідомлення про збої формулюються за випадком `HokusaiError`; скасування завершується зі статусом 130.

## Середовище та метадані {#runtime-and-metadata}

```bash
hokusai --version      # 2.2.2
hokusai info
hokusai inspect --input photo.jpg --json
```

`info` — це діагностика «швидко завершитися помилкою»: єдина рутинна команда, що викликає `Hokusai.initialize()`. На машині документації:

```text
│ libvips         │ 8.18.7                                           │
│ Cairo           │ 1.18.6                                           │
│ Input formats   │ jpeg, png, webp, gif, tiff, avif, heif, pdf, svg │
│ Blocked input   │ none                                             │
│ Output formats  │ jpeg, png, webp, gif, tiff, avif, heif, pdf      │
│ Text rendering  │ yes                                              │
│ Max evaluations │ 12                                               │
│ libvips threads │ 8                                                │
```

`inspect --json` друкує факти про джерело одним об'єктом (`phone.jpg`):

```json
{"bitsPerSample":8,"channels":3,"density":{"horizontal":72,"vertical":72},"embedded":{"exif":true,"icc":false,"iptc":false,"xmp":false},"format":"jpeg","hasAlpha":false,"height":1600,"interpretation":"sRGB","isAnimated":false,"orientation":"right","orientedHeight":1000,"orientedWidth":1600,"pages":1,"sampleFormat":"uint8","sourceByteSize":157267,"width":1000}
```

## Застарілі команди {#deprecated-commands}

`resize`, `thumbnail`, `convert`, `rotate`, `crop` і `text` ще працюють, друкують повідомлення про застарілість у стандартний потік помилок і будуть вилучені в наступному мажорному релізі:

```text
warning: `hokusai resize` is deprecated and will be removed in the next major version; use `hokusai run <input> resize --width ... -o <output>`
```

Використовуйте `hokusai run`. Їхні значення за замовчуванням збігаються з бібліотекою: `resize` вписує з `cover` (було `inside`), а текст має 24 пункти й чорний колір (було 48, білий). `convert` відмовляється приймати прапорець, що не потрібен його формату виводу, і застосовує типову політику метаданих Hokusai, якщо не задано `--strip-metadata`. Оптимізована команда `thumbnail` зберігає власний завантажувач, доки не з'явиться публічний конвеєр мініатюр.

## Бенчмарк конвеєра {#benchmark-a-pipeline}

```bash
hokusai benchmark run --input photo.jpg --workloads thumbnail-jpeg,cover-webp \
  --profile quick --evaluations 1,4 --vips-concurrency auto --json-output result.json
hokusai benchmark compare --help
```

`benchmark run` перебирає `--evaluations` × `--vips-concurrency` і запускає **новий робочий процес для кожної комірки**, тож кожне вимірювання має одну зафіксовану конфігурацію середовища; паралельні запити читають окремі копії входу, щоб кеш операцій libvips не впливав на результат. Навантаження: `thumbnail-jpeg`, `cover-webp`, `blur-webp`, `resize-png`, `stream-ttfb`, `stream-slow-consumer`, `pdf-a4`. Профілі: `quick` (локальна перевірка) і `stable` (достатньо вибірок для хвостової затримки; перцентилі, яких вибірка не підтримує, пропускаються). JSON-результат версіонований (`schemaVersion`) і записує коміт, версії, налаштування середовища, SHA-256 входу, сирі вибірки, перцентилі, пропускну здатність, пікові значення активних/черги та піковий RSS. `benchmark compare` повідомляє різницю за комірками, позначає лише зміни, що перевищують і відносний, і абсолютний поріг, та попереджає, коли нативні стеки відрізняються; він лише дорадчий.

Швидкий запуск на машині документації (ноутбук; у вас буде інакше) вивів:

| Навантаження | Eval | Запитів/с | p50 | Піковий RSS |
| --- | --- | --- | --- | --- |
| thumbnail-jpeg | 1 | 556 | 3,4 мс | 64 МБ |
| thumbnail-jpeg | 4 | 481 | 10,6 мс | 124 МБ |
| cover-webp | 1 | 52 | 37,8 мс | 73 МБ |
| cover-webp | 4 | 159 | 44,1 мс | 144 МБ |

Більша кількість обчислень підвищила пропускну здатність для повільнішого навантаження WebP і не для дуже швидкого JPEG, тоді як пам'ять приблизно подвоїлася: вимірюйте, перш ніж задавати `maxConcurrentEvaluations` ([Середовище виконання](/oss/hokusai/uk/runtime-performance/runtime)).
