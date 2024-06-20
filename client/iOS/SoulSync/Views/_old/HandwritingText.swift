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
                    let yPosition = rect.midY - position.y
                    let transform = CGAffineTransform(translationX: xPosition, y: yPosition).scaledBy(x: 1, y: -1)
                    path.addPath(Path(letter).applying(transform))
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

extension HandwritingText {
    struct Preview: View {
        @State var progress: CGFloat = 0.0
        let text: String
        let fontSize: CGFloat
        let fontName: String
        let duration: Double
        
        var body: some View {
            
            HandwritingText(text: text, fontSize: fontSize, fontName: fontName, progress: progress)
                .stroke(Color.black, lineWidth: 2)
                .frame(width: 300, height: 100)
                .onAppear {
                    withAnimation(.linear(duration: duration)) {
                        progress = 1.0
                    }
                }
        }
    }
}

#Preview {
    HandwritingText.Preview(text: "SoulSync", fontSize: 52, fontName: "Weather-Sunday---Personal-Use", duration: 4)
        .padding(.trailing, UIScreen.main.bounds.width / 2)
        .onAppear {
            for family in UIFont.familyNames.sorted() {
                let names = UIFont.fontNames(forFamilyName: family)
                print("Family: \(family) Font names: \(names)")
            }
        }
}
