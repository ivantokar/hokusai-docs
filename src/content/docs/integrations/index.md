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

A runnable Vapor demo with a web UI lives in [hokusai-vapor-example](https://github.com/ivantokar/hokusai-vapor-example); the unified examples repository and the web and macOS playgrounds are tracked in [hokusai#161–#165](https://github.com/ivantokar/hokusai/issues/161). These pages do not depend on them: every snippet here is executed or compiled by this repository.

## Guides {#guides}

- [SwiftNIO buffers](/oss/hokusai/integrations/nio)
- [Vapor: a complete service](/oss/hokusai/integrations/vapor-service)
- [Hokusai Hummingbird](/oss/hokusai/integrations/hummingbird)
- [macOS](/oss/hokusai/integrations/macos)
- [Docker](/oss/hokusai/integrations/docker)

## Read next

- [Uploads & responses](/oss/hokusai/vapor/uploads-and-responses)
