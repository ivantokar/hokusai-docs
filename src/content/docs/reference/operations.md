---
pageId: reference.operations
title: Operation index
description: Every Hokusai operation, grouped by what it does.
---

Every method of a `Hokusai` pipeline, grouped by family. Each family page lists what its operations do; the precise signatures and defaults are in the source comments of the library.

## Create {#create}

Guides: [Input options](/oss/hokusai/sources-input/input-options), [Raw pixels](/oss/hokusai/sources-input/raw-pixels), [Large uploads](/oss/hokusai/sources-input/uploads), [Generated text](/oss/hokusai/text-composition/text).

[Sources & input](/oss/hokusai/sources-input/): `init(data:)`, `init(url:)`, `init(raw:)`, `init(spooling:)`, `text(_:)`.

## Geometry {#geometry}

Guides: [Resize](/oss/hokusai/geometry/resize), [Crop & canvas](/oss/hokusai/geometry/crop-and-canvas), [Rotate, flip & affine](/oss/hokusai/geometry/rotate-flip-affine).

[Geometry](/oss/hokusai/geometry/): `autoOrient()`, `resize(`, `rotate(`, `flip()`, `flop()`, `extract(`, `extend(`, `affine(`, `trim(`, `smartCrop(`.

## Effects and color {#effects-and-color}

Guides: [Blur & sharpen](/oss/hokusai/effects-color/blur-sharpen), [Tone & color](/oss/hokusai/effects-color/tone-and-color), [Filters](/oss/hokusai/effects-color/filters).

[Effects & color](/oss/hokusai/effects-color/): `blur(`, `sharpen(`, `grayscale()`, `tint(`, `normalize(`, `clahe(`, `gamma(`, `negate(`, `median(`, `convolve(`, `linear(`, `recombine(`, `dilate(`, `erode(`, `edges(`, `threshold(`, `modulate(`, `convert(`.

## Channels and transparency {#channels-and-transparency}

Guide: [Channels & alpha](/oss/hokusai/channels-transparency/alpha-and-channels).

[Channels & transparency](/oss/hokusai/channels-transparency/): `extractChannel(`, `withAlpha(`, `ensureAlpha(`, `flatten(`, `removeAlpha()`.

## Text and composition {#text-and-composition}

Guides: [Generated text](/oss/hokusai/text-composition/text), [Composition](/oss/hokusai/text-composition/composite).

[Text & composition](/oss/hokusai/text-composition/): `composite(`, `drawText(`, `text(`.

## Encoders and output {#encoders-and-output}

Guides: [Encoders](/oss/hokusai/encoding-output/formats), [Output terminals](/oss/hokusai/encoding-output/terminals), [Metadata retention](/oss/hokusai/encoding-output/metadata), [Raster PDF](/oss/hokusai/pdf/raster), [Vector documents](/oss/hokusai/pdf/vector).

[Encoding & output](/oss/hokusai/encoding-output/): `encode(`, `jpeg(`, `png(`, `webp(`, `avif(`, `heif(`, `tiff(`, `gif(`, `pdf(` (see [PDF](/oss/hokusai/pdf/)), `metadataPolicy(`, `data()`, `write(`, `writeChunks(`, `raw(`.

## Inspection {#inspection}

Guide: [Reading metadata](/oss/hokusai/inspection/metadata).

[Inspection](/oss/hokusai/inspection/): `metadata()`.

## Runtime {#runtime}

Guides: [Runtime configuration](/oss/hokusai/runtime-performance/runtime), [Performance](/oss/hokusai/runtime-performance/performance).

[Runtime & performance](/oss/hokusai/runtime-performance/): `initialize()`, `configure(`, `capabilities()`.
