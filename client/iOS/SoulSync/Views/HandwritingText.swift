//
//  HandwrittingText.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/18/24.
//

import SwiftUI

import SwiftUI

struct HandwritingText: Shape {
    var text: String
    var fontSize: CGFloat
    var fontName: String
    var progress: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let font = CTFontCreateWithName(fontName as CFString, fontSize, nil)
        let attrString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        let line = CTLineCreateWithAttributedString(attrString)
        let runArray = CTLineGetGlyphRuns(line) as! [CTRun]

        for run in runArray {
            let attributes = CTRunGetAttributes(run) as! [CFString: Any]
            let runFont = attributes[kCTFontAttributeName] as! CTFont
            let glyphCount = CTRunGetGlyphCount(run)
            for i in 0..<glyphCount {
                let range = CFRange(location: i, length: 1)
                var glyph = CGGlyph()
                var position = CGPoint.zero
                CTRunGetGlyphs(run, range, &glyph)
                CTRunGetPositions(run, range, &position)

                if let letter = CTFontCreatePathForGlyph(runFont, glyph, nil) {
                    let xPosition = position.x + rect.midX - CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
                    let yPosition = position.y + rect.midY - CTFontGetCapHeight(runFont) / 2
                    path.addPath(Path(letter).offsetBy(dx: xPosition, dy: yPosition))
                }
            }
        }

        return path.trimmedPath(from: 0, to: progress)
    }

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
}

#Preview {
    HandwritingText()
}
