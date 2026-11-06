---
pageId: runtime-performance.index
title: Runtime & performance
description: Native runtime, scheduling and limits.
---

- `Hokusai.initialize()` starts the native runtime early; otherwise it starts on first use.
- `Hokusai.configure(_:)` freezes process-level settings (`RuntimeConfiguration`: `maxConcurrentEvaluations`, `maxQueuedEvaluations`, `vipsConcurrency`, `maxOutputPixels`, `blockUntrustedOperations`) before the first image.
- `Hokusai.capabilities()` reports the libvips and Cairo versions and which formats this process can read and write.
- `Hokusai.runtimeStatus` reports running and queued evaluations.

Evaluations beyond the limit wait as suspended tasks in FIFO order. Do not shut the runtime down in server code. Input is bounded by `InputLimits` and, for sequential access, by `InputOptions.access`.

## Guides {#guides}

- [Runtime configuration](/oss/hokusai/runtime-performance/runtime)
- [Performance](/oss/hokusai/runtime-performance/performance)

## Read next

- [Installation & requirements](/oss/hokusai/guide/installation)
- [CLI reference](/oss/hokusai/reference/cli)
