---
title: CLI Reference
---

The first-party `hokusai` executable helps inspect, transform, and benchmark local images. It is included with the Hokusai package.

## Runtime and metadata

```bash
hokusai info
hokusai inspect --input photo.jpg
```

`info` displays the Hokusai and libvips versions. `inspect` reports image dimensions, channels, alpha availability, and detected format.

## Image commands

```bash
hokusai resize --input photo.jpg --output social.webp \
  --width 1200 --height 630 --fit cover

hokusai thumbnail --input photo.jpg --output thumb.jpg --width 400

hokusai convert --input photo.jpg --output document.pdf

hokusai crop --input photo.jpg --output crop.jpg \
  --x 100 --y 80 --width 640 --height 480

hokusai rotate --input photo.jpg --output rotated.png --angle 90
```

`resize` supports `inside`, `outside`, `fill`, `cover`, and `contain` fit modes, along with kernels and scaling guards. `thumbnail` supports `none`, `centre`, `attention`, and `entropy` crop strategies.

## Text rendering

```bash
hokusai text --input photo.jpg --output titled.webp \
  --text "Hello, Hokusai" --x 80 --y 680 \
  --font "sans Bold" --font-size 48 \
  --color 255,255,255,255 --stroke-width 2 \
  --stroke-color 0,0,0,255
```

The text command supports alignment, wrapping bounds, stroke, shadow, opacity, and rotation. Fonts must be available locally on the host.

## Benchmark a pipeline

```bash
hokusai benchmark pipeline --input photo.jpg --sigma 50
```

Use the command's help for detailed options, including encoder quality and effort, warmup/iteration counts, concurrency overrides, a concurrency sweep, and JSON output:

```bash
hokusai benchmark pipeline --help
```
