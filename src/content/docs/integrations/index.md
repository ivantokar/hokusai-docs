---
pageId: integrations.index
title: Integrations
description: Hokusai in web frameworks and NIO.
---

| Package | Version | Provides |
| --- | --- | --- |
| [Hokusai Vapor](/oss/hokusai/vapor/overview) | 2.1.0 | `req.hokusaiImage()`, multipart fields, `response()`, `HokusaiErrorMiddleware`, `app.hokusai` |
| [Hokusai Hummingbird](https://github.com/ivantokar/hokusai-hummingbird) | 2.1.0 | `hokusaiImage()` for requests, `response()`, `HokusaiErrorMiddleware` |
| `HokusaiNIO` (in the core package) | 2.2.2 | `ByteBuffer` inputs and outputs, streaming buffers |

Adapters share only the major version of the core library.

## Demo applications {#demos}

Runnable demos live in [hokusai-examples](https://github.com/ivantokar/hokusai-examples) ([how to run, test and adopt them](/oss/hokusai/integrations/examples)): one web playground served by a Vapor backend and by a Hummingbird backend, and a native macOS playground, all generating the Swift that reproduces what you build. These pages do not depend on them: every snippet here is executed or compiled by this repository.

## Guides {#guides}

- [SwiftNIO buffers](/oss/hokusai/integrations/nio)
- [Vapor: a complete service](/oss/hokusai/integrations/vapor-service)
- [Hokusai Hummingbird](/oss/hokusai/integrations/hummingbird)
- [macOS](/oss/hokusai/integrations/macos)
- [Docker](/oss/hokusai/integrations/docker)
- [Examples: run, test and adopt the demos](/oss/hokusai/integrations/examples)

## Read next

- [Uploads & responses](/oss/hokusai/vapor/uploads-and-responses)
