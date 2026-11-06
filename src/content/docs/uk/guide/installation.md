---
pageId: guide.installation
translatedFrom: ff2fbbb841e5
title: Встановлення та вимоги
---

Hokusai — це пакет Swift 6 на базі libvips і Cairo.

## Вимоги {#requirements}

- Swift 6.0 або новіший
- macOS 13 або новіша, чи Linux Ubuntu/Debian
- libvips 8.9 або новіша
- Підтримка PDF у Cairo та `pkg-config`

Установіть нативні залежності до збирання застосунку:

::: code-group

```bash [macOS]
brew install vips cairo pkg-config
```

```bash [Ubuntu / Debian]
sudo apt update
sudo apt install libvips-dev libcairo2-dev pkg-config
```

:::

## Додавання Hokusai {#add-hokusai}

```swift
dependencies: [
    .package(url: "https://github.com/ivantokar/hokusai.git", from: "1.0.0")
]
```

```swift
.target(
    name: "YourApp",
    dependencies: ["Hokusai"]
)
```

Додаткові продукти пакета:

- `HokusaiNIO` забезпечує міст до `ByteBuffer` зі SwiftNIO.
- `HokusaiLegacy` надає тимчасові адаптери 0.x на час міграції.

## Перевірка середовища виконання {#verify-the-runtime}

Перше завантаження конвеєра ініціалізує Hokusai автоматично. Якщо застосунок має швидко завершуватися помилкою, коли нативне середовище недоступне, ініціалізуйте його під час запуску:

```swift
try Hokusai.initialize()
```

Команда CLI `hokusai info` показує версії Hokusai та libvips у встановленому проєкті.
