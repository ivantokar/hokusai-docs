---
pageId: geometry.index
translatedFrom: "676fd511b8fb"
title: Геометрія
description: Зміна розміру, обрізання, обертання та перетворення пікселів сітки.
---

| Операція | Що робить |
| --- | --- |
| `autoOrient()` | Застосовує орієнтацію EXIF джерела. |
| `resize(width:height:fit:position:kernel:withoutEnlargement:withoutReduction:background:)` | Змінює розмір з режимом `fit` (`inside`, `outside`, `fill`, `cover`, `contain`) і позицією обрізання. |
| `rotate(by:background:interpolation:)` | Обертає за годинниковою стрілкою на задану кількість градусів; прямі кути без втрат. |
| `flip()`, `flop()` | Віддзеркалюють по вертикалі та по горизонталі. |
| `extract(x:y:width:height:)` | Обрізає прямокутник. |
| `extend(to:anchor:background:)`, `extend(to:anchor:mode:)`, `extend(top:left:bottom:right:mode:)` | Додає полотно, заповнене кольором, копією, повтором або дзеркалом. |
| `affine(_:inputOffset:outputOffset:outputArea:edges:interpolation:)` | Застосовує афінну матрицю. |
| `trim(threshold:)`, `trim(_:)` | Прибирає однорідну рамку. |
| `smartCrop(width:height:strategy:)` | Обрізає до найцікавішої ділянки (`attention` або `entropy`). |

## Посібники {#guides}

- [Зміна розміру](/oss/hokusai/uk/geometry/resize)
- [Обрізання та полотно](/oss/hokusai/uk/geometry/crop-and-canvas)
- [Обертання, віддзеркалення та афінні перетворення](/oss/hokusai/uk/geometry/rotate-flip-affine)

## Читайте далі {#read-next}

- [Перетворення](/oss/hokusai/uk/guide/transformations)
- [Індекс операцій](/oss/hokusai/uk/reference/operations)
