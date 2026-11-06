---
pageId: changelog
title: Changelog
---

Release notes of the library, newest first. The complete history, with every change and issue reference, is in the [Hokusai repository](https://github.com/ivantokar/hokusai/blob/main/CHANGELOG.md).

## 2.2.2 — 2026-11-06 {#222--2026-11-06}

Fixes for vector PDF documents and spooled uploads: cancelling a `VectorDocument` write now stops the work, pages are drawn one at a time so memory is that of one page, and blocking file I/O no longer runs on Swift's cooperative threads.

## 2.2.1 — 2026-11-05 {#221--2026-11-05}

`hokusai --version` prints the release version. Each GitHub Release carries a prebuilt macOS arm64 `hokusai` archive.

## 2.2.0 — 2026-11-05 {#220--2026-11-05}

New API: raw pixels (`Hokusai(raw:...)`, `raw(_:)`), large uploads (`Hokusai(spooling:)`), advanced filters (`convolve`, `linear`, `recombine`, `dilate`, `erode`, `edges`, `extractChannel`, `withAlpha`), the `HokusaiPDF` product for vector PDF documents, and `hokusai run`. The older `resize`, `thumbnail`, `convert`, `rotate`, `crop` and `text` commands are deprecated and their defaults now match the library.

## 2.1.0 — 2026-11-04 {#210--2026-11-04}

Audit fixes and `RuntimeConfiguration.maxOutputPixels`. `clahe` now equalises lightness and keeps colour, so its output on colour images differs from before. `write(to:)` refuses a destination the pipeline reads.

## 2.0.0 — 2026-11-03 {#200--2026-11-03}

A redesigned library: `Hokusai` is the only image type, an immutable pipeline built synchronously and evaluated by an async terminal. Adds backpressured streaming output (`writeChunks`), `HokusaiNIO`, and a benchmark harness. Requires Swift 6.0+, libvips 8.16+ and Cairo 1.16+.
