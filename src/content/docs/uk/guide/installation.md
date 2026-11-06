---
pageId: guide.installation
translatedFrom: 12dc540abb27
title: Встановлення та вимоги
---

Hokusai — це пакет Swift 6 на базі libvips і Cairo.

## Вимоги {#requirements}

- Swift 6.0 або новіший
- macOS 13 або новіша, чи Linux
- libvips 8.16 або новіша (старіші версії відхиляються під час компіляції)
- Cairo 1.16 або новіша з підтримкою PDF та `pkg-config`
- Pango 1.44 або новіша, лише для продукту `HokusaiPDF`

Установіть нативні залежності до збирання застосунку:

У macOS:

```bash
brew install vips cairo pkg-config
```

У Debian 13 або Ubuntu 25.10 і новіших, де libvips має версію 8.16 або новішу:

```bash
sudo apt update
sudo apt install libvips-dev libcairo2-dev pkg-config
```

Ubuntu 24.04 LTS (libvips 8.15) і Debian 12 постачаються зі старішою libvips, тож там `apt install libvips-dev` недостатньо: зберіть libvips із [релізного архіву](https://github.com/libvips/libvips/releases).

Які кодеки доступні (HEIF/AVIF, JPEG XL, SVG, текст Pango), залежить від того, як зібрано libvips; `hokusai info` показує, що підтримує ваше встановлення.

## Додавання Hokusai {#add-hokusai}

```swift
dependencies: [
    .package(url: "https://github.com/ivantokar/hokusai.git", from: "2.0.0")
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
- `HokusaiPDF` малює векторні PDF-документи з виділюваним текстом; це єдиний продукт, якому потрібна Pango.

## Перевірка середовища виконання {#verify-the-runtime}

Перше завантаження конвеєра ініціалізує Hokusai автоматично. Якщо застосунок має швидко завершуватися помилкою, коли нативне середовище недоступне, ініціалізуйте його під час запуску:

```swift
try Hokusai.initialize()
```

Команда CLI `hokusai info` показує версії Hokusai та libvips у встановленому проєкті.
