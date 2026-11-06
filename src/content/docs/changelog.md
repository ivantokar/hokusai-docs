---
pageId: changelog
title: Changelog
---

## 1.0.0 — 2026-08-05

### Added

- Immutable `Hokusai` pipelines with typed `Data`, file `URL`, and optional SwiftNIO `ByteBuffer` inputs.
- Async `data()` and `write(to:)` output terminals plus typed JPEG, PNG, WebP, AVIF, and PDF encoders.
- Cairo-backed one-page PDF export.
- `HokusaiLegacy` for temporary 0.x adapter migration.

### Changed

- Hokusai 1.0 adopts `Hokusai(data:)` and `Hokusai(url:)` as its core loading APIs.
- Pipelines are immutable, while output encoding and file writes are asynchronous.
- Metadata is removed from outputs by default; opt in with `preserveMetadata()` when needed.

Read the full release history in the [Hokusai repository](https://github.com/ivantokar/hokusai/blob/main/CHANGELOG.md).
