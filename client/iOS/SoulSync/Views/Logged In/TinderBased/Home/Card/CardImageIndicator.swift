//
//  CardImageIndicator.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI

extension TinderEntry.Home.CardStack.Card {
    struct CardImageIndicator: View {
        let currentImageIndex: Int
        let imageCount: Int
        let preview: Bool
        
        init(currentImageIndex: Int, imageCount: Int, preview: Bool? = false) {
            self.currentImageIndex = currentImageIndex
            self.imageCount = imageCount
            self.preview = preview ?? false
        }
        
        var body: some View {
            HStack {
                ForEach(0..<imageCount, id: \.self) { index in
                    Capsule()
                        .foregroundStyle(currentImageIndex == index ? (preview ? .red : .white) : .gray)
                        .frame(width: imageIndicatorWidth, height: 4)
                        .padding(.top, 8)
                }
            }
        }
    }
}

private extension TinderEntry.Home.CardStack.Card.CardImageIndicator {
    var imageIndicatorWidth: CGFloat {
        return SizeConstants.cardWidth / CGFloat(imageCount) - 28
    }
}

#Preview {
    TinderEntry.Home.CardStack.Card.CardImageIndicator(currentImageIndex: 0, imageCount: 3, preview: true)
}
