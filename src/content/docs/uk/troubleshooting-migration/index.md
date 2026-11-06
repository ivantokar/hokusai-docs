---
pageId: troubleshooting-migration.index
translatedFrom: "b138fc3ed120"
title: Усунення проблем і міграція
description: Помилки, оновлення та історія релізів.
---

Кожна помилка — це `HokusaiError`:

| Випадок | Значення |
| --- | --- |
| `invalidInput`, `invalidOption` | Вхідні дані або параметр неприйнятні; для параметрів викидається одразу. |
| `unsupported` | Встановлена libvips або Cairo цього не вміє. |
| `decode`, `transform`, `encode`, `runtime` | Нативний крок завершився помилкою; містить `FailureContext`. |
| `io` | Файл не вдалося прочитати або записати. |
| `resource` | Перевищено ліміт (байти, пікселі, канали, черга). |

Виконайте `hokusai info`, щоб побачити нативні версії та можливості встановленого середовища.

## Посібники {#guides}

- [Усунення проблем](/oss/hokusai/uk/troubleshooting-migration/troubleshooting)

## Читайте далі {#read-next}

- [Міграція](/oss/hokusai/uk/guide/migration)
- [Журнал змін](/oss/hokusai/uk/changelog)
