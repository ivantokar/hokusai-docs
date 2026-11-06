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

:::note[Detailed guides are in progress]
This page lists what Hokusai provides in the documented release. Operation-by-operation guides with parameters, defaults, visual results and interactions are being added; the precise API contract is in the source comments of the library.
:::

## Read next

- [Uploads & responses](/oss/hokusai/vapor/uploads-and-responses)
