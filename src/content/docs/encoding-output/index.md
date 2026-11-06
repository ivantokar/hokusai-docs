---
pageId: encoding-output.index
title: Encoding & output
description: Encoders, terminals and metadata retention.
---

**Encoders** choose the output format: `jpeg`, `png`, `webp`, `avif`, `heif`, `tiff`, `gif` and `pdf`, each with a short form and an `options:` form (`JPEGOptions`, `PNGOptions`, `WebPOptions`, `AVIFOptions`, `HEIFOptions`, `TIFFOptions`, `GIFOptions`).

**Terminals** produce the result: `data()` returns `Output` bytes and `OutputInfo`, `write(to:)` writes a file atomically, `writeChunks(chunkSize:_:)` streams, `raw(_:premultiplied:background:)` returns raw pixels. `HokusaiNIO` adds `byteBuffer()` and `writeByteBuffers`.

**Metadata** kept in the output is a typed `MetadataPolicy` applied by `metadataPolicy(_:)`. By default EXIF, XMP, IPTC and comments are removed while ICC profile, orientation and density are kept.

What the installed libvips can read and write is reported by `Hokusai.capabilities()`.

:::note[Detailed guides are in progress]
This page lists what Hokusai provides in the documented release. Operation-by-operation guides with parameters, defaults, visual results and interactions are being added; the precise API contract is in the source comments of the library.
:::

## Read next

- [Formats & compatibility](/oss/hokusai/reference/formats-and-compatibility)
- [PDF](/oss/hokusai/pdf/)
