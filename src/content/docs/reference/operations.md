---
pageId: reference.operations
title: Operation index
description: Every Hokusai operation, grouped by what it does.
---

Every method of a `Hokusai` pipeline, grouped by family. Each family page lists what its operations do; the precise signatures and defaults are in the source comments of the library.

## Create {#create}

[Sources & input](/oss/hokusai/sources-input/): `init(data:)`, `init(url:)`, `init(raw:)`, `init(spooling:)`, `text(_:)`.

## Geometry {#geometry}

[Geometry](/oss/hokusai/geometry/): `autoOrient()`, `resize(`, `rotate(`, `flip()`, `flop()`, `extract(`, `extend(`, `affine(`, `trim(`, `smartCrop(`.

## Effects and color {#effects-and-color}

[Effects & color](/oss/hokusai/effects-color/): `blur(`, `sharpen(`, `grayscale()`, `tint(`, `normalize(`, `clahe(`, `gamma(`, `negate(`, `median(`, `convolve(`, `linear(`, `recombine(`, `dilate(`, `erode(`, `edges(`, `threshold(`, `modulate(`, `convert(`.

## Channels and transparency {#channels-and-transparency}

[Channels & transparency](/oss/hokusai/channels-transparency/): `extractChannel(`, `withAlpha(`, `ensureAlpha(`, `flatten(`, `removeAlpha()`.

## Text and composition {#text-and-composition}

[Text & composition](/oss/hokusai/text-composition/): `composite(`, `drawText(`, `text(`.

## Encoders and output {#encoders-and-output}

[Encoding & output](/oss/hokusai/encoding-output/): `encode(`, `jpeg(`, `png(`, `webp(`, `avif(`, `heif(`, `tiff(`, `gif(`, `pdf(` (see [PDF](/oss/hokusai/pdf/)), `metadataPolicy(`, `data()`, `write(`, `writeChunks(`, `raw(`.

## Inspection {#inspection}

[Inspection](/oss/hokusai/inspection/): `metadata()`.

## Runtime {#runtime}

[Runtime & performance](/oss/hokusai/runtime-performance/): `initialize()`, `configure(`, `capabilities()`.
