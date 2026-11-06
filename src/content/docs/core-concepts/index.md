---
pageId: core-concepts.index
title: Core concepts
description: How Hokusai pipelines work.
---

Hokusai is built on three ideas.

- **Immutable.** Every operation returns a new `Hokusai` value; the source pipeline is unchanged and can be reused or branched across tasks.
- **Deferred.** Building a pipeline only records what to do. The image is opened and processed when a terminal, `data()` or `write(to:)`, runs, so decode and pixel-dependent errors are thrown there. Option validation (dimensions, quality, colours) still happens immediately.
- **Ordered.** A pipeline means exactly the operations you wrote, in the order you wrote them. Hokusai may change how it runs them, never what they produce: it does not reorder operations, fuse resizes or keep results between evaluations.

Terminals run the blocking native work off Swift's cooperative executor. Cancelling the calling task stops the work and throws `CancellationError`.

## Guides {#guides}

- [Deferred evaluation](/oss/hokusai/core-concepts/evaluation)
- [Order of operations](/oss/hokusai/interactions/)

## Read next

- [Pipelines & concurrency](/oss/hokusai/guide/pipelines)
- [Sources & input](/oss/hokusai/sources-input/)
- [Encoding & output](/oss/hokusai/encoding-output/)
