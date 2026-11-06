---
pageId: troubleshooting-migration.index
title: Troubleshooting & migration
description: Errors, upgrades and release history.
---

Every failure is a `HokusaiError`:

| Case | Meaning |
| --- | --- |
| `invalidInput`, `invalidOption` | The input or an option is not acceptable; thrown immediately for options. |
| `unsupported` | The installed libvips or Cairo cannot do it. |
| `decode`, `transform`, `encode`, `runtime` | A native step failed; carries a `FailureContext`. |
| `io` | A file could not be read or written. |
| `resource` | A limit (bytes, pixels, channels, queue) was exceeded. |

Run `hokusai info` to see the native versions and capabilities of the runtime you installed.

## Guides {#guides}

- [Troubleshooting](/oss/hokusai/troubleshooting-migration/troubleshooting)

## Read next

- [Migration](/oss/hokusai/guide/migration)
- [Changelog](/oss/hokusai/changelog)
