---
pageId: channels-transparency.index
title: Channels & transparency
description: Named channels and the alpha channel.
---

| Operation | What it does |
| --- | --- |
| `extractChannel(_:)` | One channel (`red`, `green`, `blue`, `alpha`, `luminance`) as a grayscale image. |
| `withAlpha(from:)` | Uses another pipeline as the alpha channel. |
| `ensureAlpha(opacity:)` | Adds an alpha channel when there is none. |
| `flatten(background:)` | Composites onto a solid colour and removes alpha. |
| `removeAlpha()` | Drops the alpha channel. |

## Guides {#guides}

- [Channels & alpha](/oss/hokusai/channels-transparency/alpha-and-channels)

## Read next

- [Text & composition](/oss/hokusai/text-composition/)
- [Operation index](/oss/hokusai/reference/operations)
