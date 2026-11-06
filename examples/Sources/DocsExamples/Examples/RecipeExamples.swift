import Foundation
import Hokusai
import HokusaiPDF

extension Example {
    static let recipeSocialCard = Example("recipe.social-card") {
        // snippet: recipe.social-card
        // 1200 × 630 is the usual size for link previews.
        func socialCard(from photo: URL, title: String) throws -> Hokusai {
            var style = TextStyle(font: "sans Bold", fontSize: 64, color: .white)
            style.shadow = TextShadow(offsetX: 3, offsetY: 3, blur: 4, color: Color(red: 0, green: 0, blue: 0, opacity: 0.75))

            return try Hokusai(url: photo)
                .autoOrient()
                .resize(width: 1200, height: 630, fit: .cover, position: .attention)
                .drawText(.plain(title), placement: .gravity(.southWest, offsetX: 56, offsetY: 48),
                          layout: .width(900), style: style)
        }

        let card = try socialCard(from: URL(fileURLWithPath: "scene.png"), title: "Keeping the light: a year at Pharos Point")
        try await card.webp(quality: 82).write(to: URL(fileURLWithPath: "card.webp"))
        try await card.jpeg(quality: 85).write(to: URL(fileURLWithPath: "card.jpg"))      // fallback for crawlers
        // Variation: the same recipe from a phone photo, which needs autoOrient.
        try await socialCard(from: URL(fileURLWithPath: "phone.jpg"), title: "From a phone, upright")
            .webp(quality: 82).write(to: URL(fileURLWithPath: "card-from-phone.webp"))
        // endsnippet
    }

    static let recipeThumbnails = Example("recipe.thumbnails") {
        // snippet: recipe.thumbnails
        // One source, several sizes, produced concurrently: pipelines are immutable, so they branch safely.
        let source = try Hokusai(url: URL(fileURLWithPath: "scene.png")).autoOrient()
        let widths = [320, 640, 1280]

        try await withThrowingTaskGroup(of: (Int, OutputInfo).self) { group in
            for width in widths {
                group.addTask {
                    // withoutEnlargement: never upscale a small original.
                    let info = try await source
                        .resize(width: width, withoutEnlargement: true)
                        .webp(quality: 80)
                        .write(to: URL(fileURLWithPath: "thumb-\(width).webp"))
                    return (width, info)
                }
            }
            for try await (width, info) in group {
                print("\(width) →", info.width, "×", info.height, info.byteCount, "bytes")
            }
        }
        // endsnippet
    }

    static let recipeWatermark = Example("recipe.watermark") {
        // snippet: recipe.watermark
        // Prepare the mark once; apply it to many images.
        let mark = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: 120)

        func watermarked(_ url: URL, width: Int) throws -> Hokusai {
            try Hokusai(url: url).autoOrient().resize(width: width)
                .composite([CompositeLayer(mark, placement: .gravity(.southEast, offsetX: 20, offsetY: 20), opacity: 0.7)])
        }

        try await watermarked(URL(fileURLWithPath: "scene.png"), width: 800).jpeg(quality: 88)
            .write(to: URL(fileURLWithPath: "wm-scene.jpg"))
        try await watermarked(URL(fileURLWithPath: "phone.jpg"), width: 500).jpeg(quality: 88)
            .write(to: URL(fileURLWithPath: "wm-phone.jpg"))

        // Variation: a diagonal tile across the whole image, very faint, for proofs.
        try await Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 800)
            .composite([CompositeLayer(mark.resize(width: 80), placement: .tile(gravity: .center), opacity: 0.18)])
            .jpeg(quality: 88).write(to: URL(fileURLWithPath: "wm-proof.jpg"))
        // endsnippet
    }

    static let recipeAvatar = Example("recipe.avatar") {
        // snippet: recipe.avatar
        let size = 256
        // A circular mask: the alpha channel of the emblem is a disc with soft edges.
        let mask = try Hokusai(url: URL(fileURLWithPath: "emblem.png")).resize(width: size).extractChannel(.alpha)

        let avatar = try Hokusai(url: URL(fileURLWithPath: "scene.png"))
            .resize(width: size, height: size, fit: .cover, position: .attention)
            .withAlpha(from: mask)

        try await avatar.png().write(to: URL(fileURLWithPath: "avatar.png"))                    // keeps transparency
        try await avatar.webp(quality: 85).write(to: URL(fileURLWithPath: "avatar.webp"))
        // Variation: for places without alpha, flatten onto the page colour and use JPEG.
        try await avatar.flatten(background: Color(red: 0.97, green: 0.95, blue: 0.9)).jpeg(quality: 90)
            .write(to: URL(fileURLWithPath: "avatar.jpg"))
        // endsnippet
    }

    static let recipeContactSheet = Example("recipe.contact-sheet") {
        // snippet: recipe.contact-sheet
        let positions: [ResizePosition] = [.west, .center, .east, .attention, .entropy, .northEast]
        let cell = 220, gap = 12, columns = 3

        // A blank paper-coloured canvas the size of the grid: one pixel, enlarged.
        let rows = (positions.count + columns - 1) / columns
        let canvas = try Hokusai(raw: Data([248, 242, 230]), width: 1, height: 1, format: .rgb8)
            .resize(width: gap + columns * (cell + gap), height: gap + rows * (cell + gap), fit: .fill, kernel: .nearest)

        // Each cell is the same photo cropped differently; place them with plain arithmetic.
        let source = try Hokusai(url: URL(fileURLWithPath: "scene.png"))
        var layers: [CompositeLayer] = []
        for (index, position) in positions.enumerated() {
            let tile = try source.resize(width: cell, height: cell, fit: .cover, position: position)
            layers.append(CompositeLayer(tile, x: gap + (index % columns) * (cell + gap), y: gap + (index / columns) * (cell + gap)))
        }
        try await canvas.composite(layers).webp(quality: 85).write(to: URL(fileURLWithPath: "sheet.webp"))
        // endsnippet
    }

    static let recipeReport = Example("recipe.report") {
        // snippet: recipe.report
        // A two-page report: raster images prepared by Hokusai, laid out as a vector document.
        let ink = Color(red: 0.1, green: 0.14, blue: 0.3)
        let source = try Hokusai(url: URL(fileURLWithPath: "scene.png"))

        var page = try VectorPage(size: .a4())
            .rectangle(VectorRect(x: 0, y: 0, width: 595.276, height: 90), fill: .color(ink))
            .text("Field report", at: VectorPoint(x: 40, y: 28), style: VectorTextStyle(size: 30, weight: .bold, color: .white))
        for (index, position) in [ResizePosition.center, .east, .attention].enumerated() {
            let photo = try source.resize(width: 480, height: 480, fit: .cover, position: position)
            page = try page.image(photo, frame: VectorRect(x: 40 + Double(index) * 180, y: 120, width: 170, height: 170), fit: .cover)
        }
        page = try page.text(.markup("Three crops of the same <b>1600 × 1000</b> original: centre, east and attention."),
                             at: VectorPoint(x: 40, y: 310), width: 515, style: VectorTextStyle(size: 12, lineSpacing: 1.3))

        let info = try await VectorDocument(page, metadata: PDFDocumentMetadata(title: "Field report"))
            .write(to: URL(fileURLWithPath: "field-report.pdf"))
        print("report →", info.pageCount, "page,", info.byteCount, "bytes")
        // endsnippet
    }

    static let recipeUpload = Example("recipe.upload") {
        // snippet: recipe.upload
        // Normalise an untrusted upload: bounded input, upright pixels, sane size, no private metadata.
        func normalise(_ upload: Data) async throws -> Output {
            try await Hokusai(
                data: upload,
                options: .init(failOn: .truncated, limits: .init(maxBytes: 20_000_000, maxPixels: 50_000_000))
            )
            .autoOrient()
            .resize(width: 1600, height: 1600, fit: .inside, withoutEnlargement: true)
            .webp(quality: 82)
            .data()                         // default metadata policy: EXIF, XMP, IPTC removed
        }

        let phone = try Data(contentsOf: URL(fileURLWithPath: "phone.jpg"))
        let output = try await normalise(phone)
        let meta = try await Hokusai(data: output.data).metadata()
        print("upload →", output.info.width, "×", output.info.height, output.info.format.rawValue,
              "exif:", meta.exif?.count ?? 0, "bytes")
        try output.data.write(to: URL(fileURLWithPath: "normalised.webp"))

        do { _ = try await normalise(Data("not an image".utf8)) } catch { print("bad upload →", type(of: error)) }
        // endsnippet
    }
}
