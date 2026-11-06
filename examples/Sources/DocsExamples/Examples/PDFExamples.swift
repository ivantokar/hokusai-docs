import Foundation
import Hokusai
import HokusaiPDF

extension Example {
    static let pdfRaster = Example("pdf.raster") {
        // snippet: pdf.raster
        let image = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 800)

        func describe(_ name: String, _ info: OutputInfo) {
            let page = info.pdf.map { "\($0.pageCount) page, \(Int($0.pageWidth.rounded())) × \(Int($0.pageHeight.rounded())) pt" } ?? "?"
            print(name, "→", page, info.byteCount, "bytes")
        }

        // Page sized from the raster: 800 px at 72 dpi is 800 pt; at 150 dpi it is 384 pt.
        describe("image", try await image.pdf().write(to: URL(fileURLWithPath: "image.pdf")))
        describe("image-150dpi", try await image.pdf(pageSize: .image(dpi: 150)).write(to: URL(fileURLWithPath: "image-150dpi.pdf")))

        // Fixed paper: the raster is fitted inside the margins and anchored (centred by default).
        describe("a4", try await image.pdf(pageSize: .a4(), margins: .all(36), background: .white)
            .write(to: URL(fileURLWithPath: "a4.pdf")))
        describe("letter-landscape", try await image.pdf(pageSize: .letter(.landscape), margins: .all(24), anchor: .north,
                                                       background: Color(red: 0.97, green: 0.95, blue: 0.9),
                                                       metadata: PDFDocumentMetadata(title: "Pharos Point", author: "Docs"))
            .write(to: URL(fileURLWithPath: "letter-landscape.pdf")))
        // endsnippet
    }

    static let pdfVector = Example("pdf.vector") {
        // snippet: pdf.vector
        let navy = Color(red: 0.1, green: 0.14, blue: 0.3)
        let teal = Color(red: 0.15, green: 0.5, blue: 0.55)
        let photo = try Hokusai(url: URL(fileURLWithPath: "scene.png"))

        let cover = try VectorPage(size: .a4())
            .background(.linearGradient(from: navy, to: teal))
            .image(photo, frame: VectorRect(x: 40, y: 40, width: 515, height: 322), fit: .cover)
            .text("Pharos Point", at: VectorPoint(x: 40, y: 390), width: 515,
                  style: VectorTextStyle(family: "sans", size: 34, weight: .bold, color: .white))
            .text("Selectable, searchable text on a vector page.", at: VectorPoint(x: 40, y: 440), width: 515,
                  style: VectorTextStyle(size: 14, color: Color(red: 0.85, green: 0.9, blue: 0.95)))

        let summary = try VectorPage(size: .a4())
            .rectangle(VectorRect(x: 40, y: 40, width: 515, height: 60), fill: .color(navy), cornerRadius: 8)
            .text("Summary", at: VectorPoint(x: 56, y: 58), style: VectorTextStyle(size: 22, weight: .bold, color: .white))
            .line(from: VectorPoint(x: 40, y: 130), to: VectorPoint(x: 555, y: 130), stroke: VectorStroke(color: teal, width: 2))
            .text(.markup("The light is visible for <b>24 nautical miles</b> and flashes every <span foreground=\"#267f8c\">ten seconds</span>."),
                  at: VectorPoint(x: 40, y: 150), width: 515, style: VectorTextStyle(size: 13, lineSpacing: 1.3))

        let document = VectorDocument(pages: [cover, summary],
                                      metadata: PDFDocumentMetadata(title: "Pharos Point", author: "Docs"))
        let info = try await document.write(to: URL(fileURLWithPath: "report.pdf"))
        print("vector document →", info.pageCount, "pages,", info.byteCount, "bytes")
        // endsnippet
    }

    static let pdfLimits = Example("pdf.limits") {
        // snippet: pdf.limits
        func attempt(_ name: String, _ run: () async throws -> String) async {
            do { print(name, "→", try await run()) } catch { print(name, "→ throws", error) }
        }
        let photo = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 400)

        await attempt("custom size 20000 pt") { _ = try VectorPage(size: .points(width: 20000, height: 100)); return "accepted" }
        await attempt("empty rectangle") { _ = try VectorPage().rectangle(VectorRect(x: 0, y: 0, width: 0, height: 10), fill: .color(.white)); return "accepted" }
        await attempt("rectangle without fill or stroke") { _ = try VectorPage().rectangle(VectorRect(x: 0, y: 0, width: 10, height: 10)); return "accepted" }
        await attempt("document without pages") { _ = try await VectorDocument(pages: []).data(); return "written" }
        await attempt("invalid markup") {
            let page = try VectorPage().text(.markup("<b>unclosed"), at: VectorPoint(x: 10, y: 10))
            _ = try await VectorDocument(page).data(); return "written"
        }
        await attempt("raster pdf, dpi 0") { _ = try photo.pdf(pageSize: .image(dpi: 0)); return "accepted" }
        // endsnippet
    }
}
