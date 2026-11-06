---
pageId: reference.cli
title: CLI Reference
---

The first-party `hokusai` executable inspects, transforms, and benchmarks local images. It is included with the Hokusai package and is a thin client of the public `Hokusai` API.

## Run a pipeline {#run-a-pipeline}

`hokusai run` is a pipeline written the way the library writes it: an input, steps named after the API methods in the order they apply, and an output.

```bash
hokusai run photo.jpg auto-orient resize --width 1200 --height 630 --fit cover \
  blur --sigma 1.5 webp --quality 82 -o social.webp --json

hokusai run --text "Hokusai" --font-size 48 png -o title.png

cat photo.jpg | hokusai run - resize --width 400 jpeg -o - > small.jpg
```

The image is decoded once and encoded once, however many steps there are. The input is a path, `-` for standard input, or `--text` / `--markup` for generated text, with the options of `InputOptions` and `InputLimits`. `-o <path>` writes a file (its extension chooses the encoder when no encoder step is given); `-o -` writes to standard output and needs an encoder step. `--json` prints the `OutputInfo` of the write. There is a step for every public operation and one for every encoder (`jpeg`, `png`, `webp`, `avif`, `heif`, `tiff`, `gif`, `pdf`), plus `metadata-policy`. Each step takes the options of its method with the method's defaults.

```bash
hokusai run --help
hokusai run photo.jpg resize --help
```

## Runtime and metadata {#runtime-and-metadata}

```bash
hokusai --version
hokusai info
hokusai inspect --input photo.jpg
```

`info` displays the Hokusai, libvips and Cairo versions and the capabilities of the installed runtime. `inspect` reports the source metadata; `--json` is available for scripts.

## Deprecated commands {#deprecated-commands}

`resize`, `thumbnail`, `convert`, `rotate`, `crop` and `text` still work, print a deprecation notice on standard error, and will be removed in the next major version. Use `hokusai run`. Their defaults match the library: `resize` fits with `cover` and text is 24 points, black.

## Benchmark a pipeline {#benchmark-a-pipeline}

```bash
hokusai benchmark run --help
hokusai benchmark compare --help
```

`benchmark run` sweeps evaluations and libvips concurrency, starting a fresh worker process for every cell, and writes a versioned JSON result. `benchmark compare` reports per-cell deltas between two results.
