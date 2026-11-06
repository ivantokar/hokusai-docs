---
title: API
---

Hokusai's API is built around immutable image pipelines: load an image, compose transformations, then evaluate an encoded result asynchronously.

## Core library

- [Pipelines & concurrency](/oss/hokusai/guide/pipelines) — loading image data, branching recipes, metadata, and lifecycle.
- [Transformations](/oss/hokusai/guide/transformations) — resize, crop, rotate, blur, sharpen, alpha, and color operations.
- [Text, composition & PDF](/oss/hokusai/guide/composition-and-pdf) — layers, local fonts, and one-page Cairo-backed PDFs.
- [Formats & compatibility](/oss/hokusai/reference/formats-and-compatibility) — typed encoder controls and 1.0 migration support.

## Vapor

Hokusai Vapor adds request decoding and image/PDF response helpers to Vapor 4.

- [Integration overview](/oss/hokusai/vapor/overview)
- [Uploads & responses](/oss/hokusai/vapor/uploads-and-responses)

## Command line

The `hokusai` executable supports runtime inspection, image transforms, text rendering, thumbnails, and pipeline benchmarks.

[Read the CLI reference](/oss/hokusai/reference/cli)
