---
pageId: changelog
translatedFrom: 11ecb66f8999
title: Журнал змін
---

## 1.0.0 — 2026-08-05 {#100--2026-08-05}

### Додано {#added}

- Незмінні конвеєри `Hokusai` з типізованими вхідними даними `Data`, файловим `URL` та, за потреби, `ByteBuffer` зі SwiftNIO.
- Асинхронні завершальні операції виводу `data()` і `write(to:)` та типізовані кодувальники JPEG, PNG, WebP, AVIF і PDF.
- Експорт односторінкового PDF на базі Cairo.
- `HokusaiLegacy` для тимчасової міграції з адаптерів 0.x.

### Змінено {#changed}

- Hokusai 1.0 використовує `Hokusai(data:)` і `Hokusai(url:)` як основні API завантаження.
- Конвеєри незмінні, а кодування виводу й запис файлів асинхронні.
- Метадані за замовчуванням вилучаються з виводу; за потреби вмикайте їх через `preserveMetadata()`.

Повну історію релізів читайте в [репозиторії Hokusai](https://github.com/ivantokar/hokusai/blob/main/CHANGELOG.md).
