---
pageId: integrations.examples
title: Examples
description: Run the Vapor or Hummingbird demo, try the macOS playground, test them, and take the code into your own app.
---

[hokusai-examples](https://github.com/ivantokar/hokusai-examples) is a repository of runnable demos. You open an image, build an ordered pipeline, see the result, and copy the Swift that reproduces it. It is the quickest way to see what Hokusai does and how the Vapor and Hummingbird adapters behave. The documentation does not depend on it: every snippet on this site is run by this site's own repository.

## What is in it {#contents}

| Folder | What it is |
| --- | --- |
| `vapor-server/` | A web playground served by a Vapor backend ([Hokusai Vapor](/oss/hokusai/vapor/overview)) |
| `hummingbird-server/` | The same playground served by a Hummingbird backend ([Hokusai Hummingbird](/oss/hokusai/integrations/hummingbird)) |
| `macos/` | A native SwiftUI playground: offline, no server |
| `recipes/` | Shared code: the operation catalog, the recipe model, the Swift code generator, a bounded upload store |
| `web/`, `fixtures/` | The one web interface both backends serve, and generated sample images |

Both backends serve the **same** web page and answer the **same** HTTP API. Run the one that matches the framework you use; the top bar shows which one answered.

## Run it with Docker {#docker}

The image builds libvips 8.16 from source (Ubuntu 24.04 ships 8.15), so the first build takes a few minutes. Nothing else needs to be installed.

```sh
git clone https://github.com/ivantokar/hokusai-examples
cd hokusai-examples
docker compose up vapor          # http://localhost:8081
docker compose up hummingbird    # http://localhost:8082
```

Both can run together: they publish different ports. Ask the running server what it can do rather than assuming: `curl localhost:8081/api/capabilities` lists the libvips and Cairo versions and the formats this runtime reads and writes.

## Run it natively {#native}

You need **Swift 6.2 or newer** and **libvips 8.16 or newer**. On macOS:

```sh
brew install vips cairo pango pkg-config
cd vapor-server && swift run App          # http://127.0.0.1:8081
# or
cd hummingbird-server && swift run App    # http://127.0.0.1:8082
```

Run it from inside the server folder: the web files and the sample images are found relative to it. On Linux, install libvips 8.16 or follow the [Docker page](/oss/hokusai/integrations/docker); the Docker route is simpler there.

| Variable | Default | Meaning |
| --- | --- | --- |
| `PORT` | 8081 (Vapor), 8082 (Hummingbird) | Port to listen on |
| `HOST` | `127.0.0.1` | Address to bind; use `0.0.0.0` in a container |
| `WEB_ROOT` | `../web` | Where the web page is read from |
| `FIXTURES_ROOT` | `../fixtures` | Where the sample images are read from |
| `HOKUSAI_MAX_CONCURRENT` | 2 | Evaluations that run at the same time |
| `HOKUSAI_MAX_QUEUED` | 2 | Evaluations allowed to wait; more are refused with 503 |

The two Hokusai limits are small on purpose, so the Runtime Lab can show a queue filling up and rejecting. Hokusai fixes them when the first image is processed, so restart the server to change them ([runtime configuration](/oss/hokusai/runtime-performance/runtime)).

## The macOS playground {#macos}

```sh
cd macos && swift run MacPlayground   # or open macos/Package.swift in Xcode
```

It runs Hokusai locally through the public API, with no server and no network. It uses the same recipe model and code generator as the web page, so a recipe means the same thing in both. It is a Swift package, not a signed `.app`: it links the Homebrew libvips.

## A first five minutes {#tour}

1. Open the page and choose a sample (or drop your own image). Everything stays in memory on the server for ten minutes.
2. Pick a **preset** such as *Thumbnail* or *Social card*. Each step is an ordinary Hokusai call; reorder, disable or edit them and the result updates.
3. Open the code drawer. The **Swift** tab prints what the page just ran, as plain Hokusai (*Core*) or inside a *Vapor* or *Hummingbird* route; **HTTP** shows the equivalent `curl`. A placeholder `input.jpg` stands in for your file.
4. **Inspect** reads the facts back from the exported bytes: which metadata survived, the raw pixel layout, the pages of a PDF or the frames of a GIF.
5. The **Runtime Lab** shows streaming, the queue and failures; **Export / PDF** compares every encoder and builds a vector PDF with selectable text.

Two things worth trying. **No photo?** Choose *Start from text* on the empty page: the recipe then makes its own pixels with `Hokusai.text`, and the generated Swift (for Vapor and Hummingbird, a `GET` route) needs no upload. **Kernels and matrices** are edited as grids of numbers: add a *Convolution kernel*, *Colour matrix* or *Affine transform* step and start from a preset such as *Emboss*, *Sepia* or *Shear*.

The preview only shrinks the *result* for display. The recipe always runs on the full original, so crops and text land exactly where the export puts them.

## The smallest integration {#minimal}

Each server has one route you can read without the demo around it: upload, resize, response.

```sh
curl --data-binary @photo.jpg 'http://localhost:8081/api/minimal/resize?width=800' -o small.webp
```

Vapor ([`vapor-server/Sources/App/main.swift`](https://github.com/ivantokar/hokusai-examples/blob/main/vapor-server/Sources/App/main.swift)):

```swift
routes.grouped(HokusaiErrorMiddleware()).post("api", "minimal", "resize") { req async throws -> Response in
    let width = min(max(req.query[Int.self, at: "width"] ?? 800, 16), 4096)
    let image = try await req.hokusaiImage(maximumSize: 5 * 1024 * 1024)   // 413 above 5 MiB
        .autoOrient()
        .resize(width: width, fit: .inside)
    return try await image.webp(quality: 82).response()                    // streamed, Content-Type: image/webp
}
```

Hummingbird ([`hummingbird-server/Sources/App/main.swift`](https://github.com/ivantokar/hokusai-examples/blob/main/hummingbird-server/Sources/App/main.swift)):

```swift
router.group("api/minimal").add(middleware: HokusaiErrorMiddleware()).post("resize") { request, _ -> Response in
    let width = min(max(request.uri.queryParameters["width"].flatMap { Int($0) } ?? 800, 16), 4096)
    let image = try await request.hokusaiImage(maximumSize: 5 * 1024 * 1024)   // 413 above 5 MiB
    let resized = try image
        .autoOrient()
        .resize(width: width, fit: .inside)
    return try await resized.webp(quality: 82).response()
}
```

The real routes also accept `?format=` so the Runtime Lab can compare encoders. Everything else in those files is the demo.

## Test it {#test}

Every check below runs in the repository's CI.

| Command | What it checks | Needs |
| --- | --- | --- |
| `swift test --package-path recipes` | The catalog, the recipe compiler, the Swift generator, the upload store | Swift, libvips |
| `swift test --package-path macos` | The macOS playground's model: undo and redo, stale results being dropped, preview against export | macOS |
| `scripts/check-snippets.sh` | The Swift the page prints compiles and runs, for every preset and the PDF template | Swift, libvips |
| `scripts/coverage.py --check` | The coverage matrix matches the operation catalog | Python 3 |
| `scripts/smoke.sh <url> <vapor\|hummingbird>` | One running backend through its HTTP API: renders, errors, metadata, queue shedding, PDF, raw pixels, layers | A running server |
| `scripts/parity.sh <url> <url>` | Two running backends answer the same requests with the same bytes, headers and errors | Both servers running |

Run the two HTTP checks against servers you started yourself:

```sh
(cd vapor-server && PORT=8081 swift run App &)
(cd hummingbird-server && PORT=8082 swift run App &)
scripts/smoke.sh http://127.0.0.1:8081 vapor
scripts/smoke.sh http://127.0.0.1:8082 hummingbird
scripts/parity.sh http://127.0.0.1:8081 http://127.0.0.1:8082
```

[`coverage/COVERAGE.md`](https://github.com/ivantokar/hokusai-examples/blob/main/coverage/COVERAGE.md) lists every public capability, where the demo shows it, and which ones are only partly or not yet shown.

## Try an unreleased library change {#local}

The demos depend on released versions. To try your own changes to a library, check it out next to the examples and use SwiftPM's edit mode in the server you run:

```sh
cd vapor-server
swift package edit hokusai --path ../../hokusai    # or hokusai-vapor
swift run App
swift package unedit hokusai                       # back to the released version
```

Never commit an edited checkout.

## Take it into your own app {#adopt}

- Start from the minimal route above and the [Vapor service](/oss/hokusai/integrations/vapor-service) or [Hummingbird](/oss/hokusai/integrations/hummingbird) page, not from the demo. The demo's upload store, queue limits and recipe model exist to serve a playground.
- The recipe model in `recipes/` is optional. It lets a UI describe a pipeline as JSON and generate Swift from it; Hokusai itself needs none of it.
- Set `RuntimeConfiguration` for your own limits and decide `blockUntrustedOperations` for untrusted uploads ([runtime](/oss/hokusai/runtime-performance/runtime)).

## When something goes wrong {#troubleshooting}

| You see | Cause and fix |
| --- | --- |
| The build fails on libvips, or a version is rejected | Hokusai 2 needs libvips 8.16 or newer. Use Docker, or `brew install vips` on macOS |
| `Address already in use` | Another process has the port. Set `PORT`, or stop the old server |
| The page loads but images are missing | The server was started from the wrong folder. Run it inside `vapor-server` or `hummingbird-server`, or set `WEB_ROOT` and `FIXTURES_ROOT` |
| 413 | The image is larger than the upload limit. The minimal route accepts 5 MiB |
| 422 | Not an image, or a step cannot apply (for example a crop outside the image) |
| 503 with a message about the queue | More requests than the running and queued limits allow. This is the Runtime Lab's point; raise `HOKUSAI_MAX_QUEUED` and restart |
| A PDF or TIFF preview says it is unavailable (501) | This runtime cannot read the format back. Docker images include what is needed; a native libvips built without poppler cannot preview PDF |
| `autoOrient` seems to do nothing | libvips was built without libexif, so the orientation tag is ignored. Check `/api/capabilities` |
| Text is missing or uses another font | Text needs fonts and a libvips built with Pango. The Docker image bundles DejaVu; native runs use your system fonts |

## Related {#related}

- [Hokusai Vapor](/oss/hokusai/vapor/overview), [Hokusai Hummingbird](/oss/hokusai/integrations/hummingbird), [macOS](/oss/hokusai/integrations/macos)
- [Docker](/oss/hokusai/integrations/docker), [Installation](/oss/hokusai/guide/installation)
