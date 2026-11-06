---
pageId: guide.installation
title: Installation & Requirements
---

Hokusai is a Swift 6 package backed by libvips and Cairo.

## Requirements

- Swift 6.0 or later
- macOS 13 or later, or Linux
- libvips 8.16 or later (older versions are rejected at compile time)
- Cairo 1.16 or later with PDF surface support, and `pkg-config`
- Pango 1.44 or later, only for the `HokusaiPDF` product

Install native dependencies before building your application:

On macOS:

```bash
brew install vips cairo pkg-config
```

On Debian 13 or Ubuntu 25.10 and newer, whose libvips is 8.16 or later:

```bash
sudo apt update
sudo apt install libvips-dev libcairo2-dev pkg-config
```

Ubuntu 24.04 LTS (libvips 8.15) and Debian 12 ship an older libvips, so `apt install libvips-dev` is not enough there: build libvips from a [release tarball](https://github.com/libvips/libvips/releases).

Which codecs are available (HEIF/AVIF, JPEG XL, SVG, Pango text) depends on how libvips was built; `hokusai info` shows what your installation supports.

## Add Hokusai

```swift
dependencies: [
    .package(url: "https://github.com/ivantokar/hokusai.git", from: "2.0.0")
]
```

```swift
.target(
    name: "YourApp",
    dependencies: ["Hokusai"]
)
```

Optional package products:

- `HokusaiNIO` bridges to SwiftNIO `ByteBuffer`.
- `HokusaiPDF` draws vector PDF documents with selectable text; it is the only product that needs Pango.

## Verify the runtime

The first pipeline load initializes Hokusai automatically. For applications that should fail early when the native runtime is unavailable, initialize during startup:

```swift
try Hokusai.initialize()
```

Use the CLI's `hokusai info` command to display the Hokusai and libvips versions in an installed project.
