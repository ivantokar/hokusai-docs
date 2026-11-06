---
title: Installation & Requirements
---

Hokusai is a Swift 6 package backed by libvips and Cairo.

## Requirements

- Swift 6.0 or later
- macOS 13 or later, or Ubuntu/Debian Linux
- libvips 8.9 or later
- Cairo PDF support and `pkg-config`

Install native dependencies before building your application:

::: code-group

```bash [macOS]
brew install vips cairo pkg-config
```

```bash [Ubuntu / Debian]
sudo apt update
sudo apt install libvips-dev libcairo2-dev pkg-config
```

:::

## Add Hokusai

```swift
dependencies: [
    .package(url: "https://github.com/ivantokar/hokusai.git", from: "1.0.0")
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
- `HokusaiLegacy` provides temporary 0.x adapters while you migrate.

## Verify the runtime

The first pipeline load initializes Hokusai automatically. For applications that should fail early when the native runtime is unavailable, initialize during startup:

```swift
try Hokusai.initialize()
```

Use the CLI's `hokusai info` command to display the Hokusai and libvips versions in an installed project.
