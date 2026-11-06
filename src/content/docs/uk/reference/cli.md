---
pageId: reference.cli
translatedFrom: 02c6217e21d7
title: Довідник CLI
---

Офіційний виконуваний файл `hokusai` допомагає перевіряти, перетворювати й тестувати продуктивність локальних зображень. Він входить до пакета Hokusai.

## Середовище виконання та метадані {#runtime-and-metadata}

```bash
hokusai info
hokusai inspect --input photo.jpg
```

`info` показує версії Hokusai та libvips. `inspect` повідомляє розміри зображення, канали, наявність альфа-каналу та визначений формат.

## Команди для зображень {#image-commands}

```bash
hokusai resize --input photo.jpg --output social.webp \
  --width 1200 --height 630 --fit cover

hokusai thumbnail --input photo.jpg --output thumb.jpg --width 400

hokusai convert --input photo.jpg --output document.pdf

hokusai crop --input photo.jpg --output crop.jpg \
  --x 100 --y 80 --width 640 --height 480

hokusai rotate --input photo.jpg --output rotated.png --angle 90
```

`resize` підтримує режими вписування `inside`, `outside`, `fill`, `cover` і `contain`, а також ядра та запобіжники масштабування. `thumbnail` підтримує стратегії обрізання `none`, `centre`, `attention` і `entropy`.

## Відтворення тексту {#text-rendering}

```bash
hokusai text --input photo.jpg --output titled.webp \
  --text "Hello, Hokusai" --x 80 --y 680 \
  --font "sans Bold" --font-size 48 \
  --color 255,255,255,255 --stroke-width 2 \
  --stroke-color 0,0,0,255
```

Команда `text` підтримує вирівнювання, межі переносу, обведення, тінь, непрозорість і обертання. Шрифти мають бути доступні локально на хості.

## Бенчмарк конвеєра {#benchmark-a-pipeline}

```bash
hokusai benchmark pipeline --input photo.jpg --sigma 50
```

Докладні параметри дивіться у довідці команди: якість і зусилля кодувальника, кількість прогрівальних та вимірювальних ітерацій, перевизначення паралельності, перебір рівнів паралельності та вивід у JSON:

```bash
hokusai benchmark pipeline --help
```
