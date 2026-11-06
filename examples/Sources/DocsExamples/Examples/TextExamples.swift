import Foundation
import Hokusai

extension Example {
    static let textLayouts = Example("text.layouts") {
        // snippet: text.layouts
        let style = TextStyle(fontSize: 40, color: Color(red: 0.1, green: 0.14, blue: 0.3))
        let sentence: TextContent = "The lighthouse keeper wound the clock every evening."

        // natural: as large as the text needs; lines break only at newlines.
        let natural = try Hokusai.text(sentence, style: style)
        // width: wrap lines to a pixel width.
        let wrapped = try Hokusai.text(sentence, layout: .width(420), style: style)
        // width with .character breaks anywhere, `.none` never breaks and clips at the width.
        let clipped = try Hokusai.text(sentence, layout: .width(420, wrap: .none), style: style)
        // fit: the largest size that fits the box (the style's dpi is not used).
        let fitted = try Hokusai.text(sentence, layout: .fit(width: 420, height: 120), style: style)

        for (name, text) in [("natural", natural), ("wrapped", wrapped), ("clipped", clipped), ("fitted", fitted)] {
            try await text.png().write(to: URL(fileURLWithPath: "\(name).png"))
        }
        // endsnippet
    }

    static let textStyles = Example("text.styles") {
        // snippet: text.styles
        let base = TextStyle(font: "sans Bold", fontSize: 72, color: Color(red: 0.1, green: 0.14, blue: 0.3))

        var stroked = base
        stroked.color = .white
        stroked.stroke = TextStroke(color: Color(red: 0.1, green: 0.14, blue: 0.3), width: 4)

        var shadowed = base
        shadowed.shadow = TextShadow(offsetX: 4, offsetY: 4, blur: 3)

        var rotated = base
        rotated.rotation = -12

        let variants: [(String, TextStyle)] = [("plain", base), ("stroke", stroked), ("shadow", shadowed), ("rotated", rotated)]
        for (name, style) in variants {
            try await Hokusai.text("Hokusai", style: style).png().write(to: URL(fileURLWithPath: "\(name).png"))
        }

        // Alignment and line height apply to multi-line text.
        var centred = TextStyle(fontSize: 36, color: Color(red: 0.1, green: 0.14, blue: 0.3))
        centred.alignment = .center
        centred.lineHeight = 1.4
        try await Hokusai.text("Hokusai\nSwift image processing", style: centred).png()
            .write(to: URL(fileURLWithPath: "centred.png"))
        // endsnippet
    }

    static let textMarkup = Example("text.markup") {
        // snippet: text.markup
        // Pango markup mixes fonts, sizes and colours in one text. (Plain text is always escaped.)
        let markup = """
        <span size="xx-large" weight="bold">Sale</span> <span foreground="#c83030">−30%</span>
        <i>this week only</i> · <span font_family="monospace">code HOKUSAI</span>
        """
        try await Hokusai.text(.markup(markup), style: TextStyle(fontSize: 36, color: Color(red: 0.1, green: 0.14, blue: 0.3)))
            .png().write(to: URL(fileURLWithPath: "markup.png"))

        // Characters that look like markup are safe in plain text.
        try await Hokusai.text(.plain("a < b & c"), style: TextStyle(fontSize: 36, color: Color(red: 0.1, green: 0.14, blue: 0.3)))
            .png().write(to: URL(fileURLWithPath: "plain-escaped.png"))
        // endsnippet
    }

    static let textDraw = Example("text.draw") {
        // snippet: text.draw
        let photo = try Hokusai(url: URL(fileURLWithPath: "scene.png")).resize(width: 640)

        var style = TextStyle(font: "sans Bold", fontSize: 40, color: .white)
        style.shadow = TextShadow(offsetX: 2, offsetY: 2, blur: 2, color: Color(red: 0, green: 0, blue: 0, opacity: 0.7))

        try await photo
            .drawText("Pharos Point", placement: .gravity(.southWest, offsetX: 24, offsetY: 20), style: style)
            .webp(quality: 88)
            .write(to: URL(fileURLWithPath: "caption.webp"))
        // endsnippet
    }

    static let textLimits = Example("text.limits") {
        // snippet: text.limits
        func attempt(_ name: String, _ build: () throws -> Hokusai) async {
            do {
                let output = try await build().png().data()
                print(name, "→", output.info.width, "×", output.info.height)
            } catch {
                print(name, "→ throws", error)
            }
        }

        let style = TextStyle(fontSize: 24)
        await attempt("hello") { try Hokusai.text("Hello", style: style) }
        await attempt("empty text") { try Hokusai.text("", style: style) }
        await attempt("font file as family") { try Hokusai.text("Hi", style: TextStyle(font: "/fonts/Inter.ttf")) }
        await attempt("fontSize 3000") { try Hokusai.text("Hi", style: TextStyle(fontSize: 3000)) }
        await attempt("fit with lineHeight") {
            var tall = TextStyle(); tall.lineHeight = 2
            return try Hokusai.text("Hi", layout: .fit(width: 200, height: 100), style: tall)
        }
        await attempt("invalid markup") { try Hokusai.text(.markup("<b>unclosed"), style: style) }
        // endsnippet
    }
}
