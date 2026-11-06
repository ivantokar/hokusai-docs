---
pageId: effects-color.index
translatedFrom: "1b35b9101c39"
title: Ефекти та колір
description: Фільтри, тон і кольорові операції.
---

| Операція | Що робить |
| --- | --- |
| `blur(sigma:precision:minAmplitude:)` | Гауссове розмиття. |
| `sharpen(sigma:)`, `sharpen(_:)` | Підвищення різкості, з `SharpenOptions` для точного налаштування. |
| `grayscale()`, `tint(_:)` | Прибирають колір або відображають яскравість на колір. |
| `normalize(lower:upper:)`, `clahe(width:height:maxSlope:)` | Розтягують контраст глобально або локально. |
| `gamma(_:)`, `modulate(brightness:saturation:hue:)`, `negate(alpha:)`, `threshold(_:grayscale:)` | Налаштування тону й кольору. |
| `median(size:)` | Медіанний фільтр. |
| `convolve(_:)`, `linear(multiply:add:)`, `recombine(_:)` | Перетворення ядром, лінійні та матричні перетворення каналів. |
| `dilate(radius:)`, `erode(radius:)`, `edges(_:)` | Морфологія та виявлення країв (`sobel`, `scharr`, `prewitt`, `canny`). |
| `convert(to:)` | Перетворює на `sRGB` або `grayscale`. |

## Посібники {#guides}

- [Розмиття та різкість](/oss/hokusai/uk/effects-color/blur-sharpen)
- [Тон і колір](/oss/hokusai/uk/effects-color/tone-and-color)
- [Фільтри](/oss/hokusai/uk/effects-color/filters)

## Читайте далі {#read-next}

- [Канали та прозорість](/oss/hokusai/uk/channels-transparency/)
- [Індекс операцій](/oss/hokusai/uk/reference/operations)
