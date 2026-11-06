---
pageId: geometry.index
translatedFrom: bd73f29fa367
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

:::note[Докладні посібники в розробці]
На цій сторінці перелічено, що надає Hokusai у задокументованому релізі. Посібники з кожної операції, з параметрами, значеннями за замовчуванням, візуальними результатами та взаємодіями, додаються; точний контракт API міститься в коментарях до вихідного коду бібліотеки.
:::

## Читайте далі {#read-next}

- [Перетворення](/oss/hokusai/uk/guide/transformations)
- [Індекс операцій](/oss/hokusai/uk/reference/operations)
