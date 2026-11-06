---
pageId: text-composition.index
translatedFrom: "e31c4e097ac6"
title: Текст і композиція
description: Згенерований текст, шари та змішування.
---

| Операція | Що робить |
| --- | --- |
| `Hokusai.text(_:layout:style:)` | Відтворює текст як новий конвеєр зі `TextStyle` (шрифт, розмір, колір, вирівнювання, обведення, тінь, обертання). |
| `drawText(_:placement:layout:style:)` | Малює текст на конвеєрі; скорочення для накладання тексту як шару. |
| `composite(_:space:)` | Змішує `CompositeLayer` (`placement`, `blend`, `opacity`) у просторі `srgb` або `linear`. |

Текст може бути звичайним або з розміткою Pango, мати природне компонування, переноситися за шириною або вписуватися в рамку. Для відтворення тексту потрібна libvips, зібрана з Pango; шрифти беруться з хоста.

## Посібники {#guides}

- [Згенерований текст](/oss/hokusai/uk/text-composition/text)
- [Композиція](/oss/hokusai/uk/text-composition/composite)

## Читайте далі {#read-next}

- [Текст, композиція та PDF](/oss/hokusai/uk/guide/composition-and-pdf)
- [Приклади](/oss/hokusai/uk/examples)
