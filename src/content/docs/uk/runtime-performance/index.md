---
pageId: runtime-performance.index
translatedFrom: "a328ad664886"
title: Середовище та продуктивність
description: Нативне середовище, планування та обмеження.
---

- `Hokusai.initialize()` запускає нативне середовище завчасно; інакше воно запускається під час першого використання.
- `Hokusai.configure(_:)` фіксує налаштування рівня процесу (`RuntimeConfiguration`: `maxConcurrentEvaluations`, `maxQueuedEvaluations`, `vipsConcurrency`, `maxOutputPixels`, `blockUntrustedOperations`) до першого зображення.
- `Hokusai.capabilities()` повідомляє версії libvips і Cairo та які формати цей процес може читати й записувати.
- `Hokusai.runtimeStatus` повідомляє про виконувані й поставлені в чергу обчислення.

Виконання понад ліміт очікують як призупинені завдання в порядку FIFO. Не завершуйте роботу середовища в серверному коді. Вхідні дані обмежують `InputLimits` і, для послідовного доступу, `InputOptions.access`.

## Посібники {#guides}

- [Конфігурація середовища виконання](/oss/hokusai/uk/runtime-performance/runtime)
- [Продуктивність](/oss/hokusai/uk/runtime-performance/performance)

## Читайте далі {#read-next}

- [Встановлення та вимоги](/oss/hokusai/uk/guide/installation)
- [Довідник CLI](/oss/hokusai/uk/reference/cli)
