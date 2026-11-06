---
pageId: reference.api
title: API
---

Hokusai's API is built around immutable image pipelines: load an image, compose transformations, then evaluate an encoded result asynchronously.

## Core library

- [Pipelines & concurrency](/oss/hokusai/guide/pipelines) — loading image data, branching recipes, metadata, and lifecycle.
- [Transformations](/oss/hokusai/guide/transformations) — resize, crop, rotate, blur, sharpen, alpha, and color operations.
- [Text, composition & PDF](/oss/hokusai/guide/composition-and-pdf) — layers, local fonts, and one-page Cairo-backed PDFs.
- [Formats & compatibility](/oss/hokusai/reference/formats-and-compatibility) — typed encoder controls for every output format and platform support.

## Vapor

Hokusai Vapor adds request decoding and streamed image/PDF responses to Vapor 4. Hokusai Hummingbird does the same for Hummingbird 2; see [Integrations](/oss/hokusai/integrations/).

- [Integration overview](/oss/hokusai/vapor/overview)
- [Uploads & responses](/oss/hokusai/vapor/uploads-and-responses)

## Command line

The `hokusai` executable supports runtime inspection, image transforms, text rendering, thumbnails, and pipeline benchmarks.

[Read the CLI reference](/oss/hokusai/reference/cli)

## Operation index {#operation-index}

Every operation grouped by what it does: [Operation index](/oss/hokusai/reference/operations). The precise contract of each symbol (parameters, defaults, errors) is in the source comments of the library; this site teaches how the operations behave and combine.
