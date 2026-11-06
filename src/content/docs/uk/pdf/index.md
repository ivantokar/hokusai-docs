---
pageId: pdf.index
translatedFrom: "61e80772dd37"
title: PDF
description: Растровий експорт у PDF і векторні PDF-документи.
---

PDF-файли створюють дві різні речі.

| | Растровий експорт | Векторні документи |
| --- | --- | --- |
| API | `image.pdf(pageSize:margins:anchor:background:maxEffectiveDPI:metadata:)` | `VectorDocument` зі сторінок `VectorPage` |
| Модуль | Hokusai | HokusaiPDF |
| Вміст | Виконаний конвеєр як одна растрова сторінка | Тла, прямокутники, лінії, зображення та справжній виділюваний текст |
| Потрібно | Cairo з підтримкою PDF | Pango 1.44 або новіша |

Розмір растрових сторінок визначається зображенням (`.image(dpi:)`), як `.a4`, `.letter` або точні `.points`. Векторний текст компонується через Pango з типізованим `VectorTextStyle` і може бути звичайним або з розміткою; заливки — суцільні кольори або лінійні градієнти.

## Посібники {#guides}

- [Растровий PDF](/oss/hokusai/uk/pdf/raster)
- [Векторні документи](/oss/hokusai/uk/pdf/vector)

## Читайте далі {#read-next}

- [Текст, композиція та PDF](/oss/hokusai/uk/guide/composition-and-pdf)
- [Кодування та вивід](/oss/hokusai/uk/encoding-output/)
