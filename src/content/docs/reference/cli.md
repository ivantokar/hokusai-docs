---
pageId: reference.cli
title: CLI Reference
---

The first-party `hokusai` executable inspects, transforms and benchmarks local images. It is part of the Hokusai package (`swift run hokusai`, or the prebuilt macOS arm64 archive attached to each GitHub Release) and is a thin client of the public `Hokusai` API: whatever a step does, the method of the same name does. The outputs quoted on this page were produced by Hokusai 2.2.2 on the documentation machine.

## hokusai run {#run-a-pipeline}

`hokusai run` is a pipeline written the way the library writes it: an input, **steps named after the API methods in the order they apply**, and an output. The image is decoded once and encoded once, however many steps there are.

```bash
hokusai run photo.jpg auto-orient resize --width 1200 --height 630 --fit cover \
  blur --sigma 1.5 webp --quality 82 -o social.webp --json

hokusai run --text "Hokusai" --font-size 48 png -o title.png

cat photo.jpg | hokusai run - resize --width 400 jpeg -o - > small.jpg
```

Running the first form on `phone.jpg` (a sideways phone photo) printed:

```json
{"byteCount":10882,"format":"webp","height":500,"mimeType":"image\/webp","output":"social.webp","width":800}
```

(`--json` prints the `OutputInfo` of the write; for a PDF it adds `pdf` with `pageCount`, `pageWidth`, `pageHeight`.) When the output is `-` the image goes to standard output and the report to standard error.

### Input and output {#input-output}

- The **input** is a path, `-` for standard input, or `--text` / `--markup` for generated text, with the fields of `InputOptions` and `InputLimits`: `--page`, `--access`, `--fail-on`, `--max-bytes`, `--max-pixels`, `--max-channels`, `--revalidate`.
- **`-o <path>`** writes a file; its extension chooses the encoder when no encoder step is given. **`-o -`** writes to standard output and needs an encoder step, because there is no name to take the format from.
- A value that starts with a dash is written with an equals sign: `--hue=-30`.
- `-v` / `--verbose` shows the native diagnostic of a failure.

### Steps {#steps}

There is one step for every public operation and one for every encoder. `hokusai run photo.jpg resize --help` prints the options of one step; each takes the method's options **with the method's defaults**.

| Group | Steps |
| --- | --- |
| Geometry | `auto-orient`, `resize`, `rotate`, `flip`, `flop`, `extract`, `extend`, `affine`, `trim`, `smart-crop` |
| Effects | `blur`, `sharpen`, `grayscale`, `tint`, `normalize`, `clahe`, `gamma`, `negate`, `median`, `threshold`, `modulate` |
| Advanced filters | `convolve`, `linear`, `recombine`, `dilate`, `erode`, `edges`, `extract-channel`, `with-alpha` |
| Colour and alpha | `convert-to`, `ensure-alpha`, `flatten`, `remove-alpha` |
| Composition and text | `composite` (repeat for more layers), `draw-text` |
| Output encoders | `jpeg`, `png`, `webp`, `avif`, `heif`, `tiff`, `gif`, `pdf`, and `metadata-policy` |

The step options mirror the API: `resize` takes `--width`, `--height`, `--fit` (`cover` by default, also `contain`, `fill`, `inside`, `outside`), `--position` (`center`, the compass points, `attention`, `entropy`), `--kernel` (default `lanczos3`), `--without-enlargement`, `--without-reduction` and `--background r,g,b[,a]`. See the matching page of each family for what the options mean.

### Errors and exit status {#errors}

Arguments are strict: unknown fit, kernel, alignment and crop words, and malformed, non-finite or out-of-range colours fail instead of falling back to a default. Range validation is Hokusai's, not repeated in the CLI:

```text
$ hokusai run scene.png resize --width 0 jpeg -o x.jpg
Error: Invalid option 'width': must be in 1...2147483647
$ echo $?
1
```

An unknown step is rejected as an unexpected argument. Failures are worded from the `HokusaiError` case; cancellation exits with status 130.

## Runtime and metadata {#runtime-and-metadata}

```bash
hokusai --version      # 2.2.2
hokusai info
hokusai inspect --input photo.jpg --json
```

`info` is the fail-fast diagnostic: the only routine command that calls `Hokusai.initialize()`. On the documentation machine:

```text
│ libvips         │ 8.18.7                                           │
│ Cairo           │ 1.18.6                                           │
│ Input formats   │ jpeg, png, webp, gif, tiff, avif, heif, pdf, svg │
│ Blocked input   │ none                                             │
│ Output formats  │ jpeg, png, webp, gif, tiff, avif, heif, pdf      │
│ Text rendering  │ yes                                              │
│ Max evaluations │ 12                                               │
│ libvips threads │ 8                                                │
```

`inspect --json` prints the source facts as one object (`phone.jpg`):

```json
{"bitsPerSample":8,"channels":3,"density":{"horizontal":72,"vertical":72},"embedded":{"exif":true,"icc":false,"iptc":false,"xmp":false},"format":"jpeg","hasAlpha":false,"height":1600,"interpretation":"sRGB","isAnimated":false,"orientation":"right","orientedHeight":1000,"orientedWidth":1600,"pages":1,"sampleFormat":"uint8","sourceByteSize":157267,"width":1000}
```

## Deprecated commands {#deprecated-commands}

`resize`, `thumbnail`, `convert`, `rotate`, `crop` and `text` still work, print a deprecation notice on standard error, and will be removed in the next major version:

```text
warning: `hokusai resize` is deprecated and will be removed in the next major version; use `hokusai run <input> resize --width ... -o <output>`
```

Use `hokusai run`. Their defaults match the library: `resize` fits with `cover` (it was `inside`) and text is 24 points, black (it was 48, white). `convert` refuses a flag its output format has no use for and applies Hokusai's default metadata policy unless `--strip-metadata` is given. The optimized `thumbnail` command keeps its own loader until a public thumbnail pipeline exists.

## Benchmark a pipeline {#benchmark-a-pipeline}

```bash
hokusai benchmark run --input photo.jpg --workloads thumbnail-jpeg,cover-webp \
  --profile quick --evaluations 1,4 --vips-concurrency auto --json-output result.json
hokusai benchmark compare --help
```

`benchmark run` sweeps `--evaluations` × `--vips-concurrency` and starts a **fresh worker process for every cell**, so each measurement has one frozen runtime configuration; concurrent requests read separate copies of the input to keep libvips' operation cache out of the result. Workloads: `thumbnail-jpeg`, `cover-webp`, `blur-webp`, `resize-png`, `stream-ttfb`, `stream-slow-consumer`, `pdf-a4`. Profiles: `quick` (local smoke) and `stable` (enough samples for tail latency; percentiles the sample count cannot support are omitted). The JSON result is versioned (`schemaVersion`) and records the commit, versions, runtime settings, input SHA-256, raw samples, percentiles, throughput, active/queued high-water and peak RSS. `benchmark compare` reports per-cell deltas, flags only changes that exceed both a relative and an absolute threshold, and warns when the native stacks differ; it is advisory.

A quick run on the documentation machine (a laptop; yours will differ) printed:

| Workload | Eval | Req/s | p50 | Peak RSS |
| --- | --- | --- | --- | --- |
| thumbnail-jpeg | 1 | 556 | 3.4 ms | 64 MB |
| thumbnail-jpeg | 4 | 481 | 10.6 ms | 124 MB |
| cover-webp | 1 | 52 | 37.8 ms | 73 MB |
| cover-webp | 4 | 159 | 44.1 ms | 144 MB |

More evaluations raised throughput for the slower WebP workload and not for the very fast JPEG one, while memory roughly doubled: measure before you set `maxConcurrentEvaluations` ([Runtime](/oss/hokusai/runtime-performance/runtime)).
