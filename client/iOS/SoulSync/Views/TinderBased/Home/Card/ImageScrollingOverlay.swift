//
//  ImageScrollingOverlay.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI

extension TinderEntry.Home.CardStack.Card {
    struct ImageScrollingOverlay: View {
        @Binding var currentImageIndex: Int
        
        let imageCount: Int
        
        var body: some View {
            HStack {
                Rectangle()
                    .onTapGesture {
                        updateImageIndex(increment: false)
                    }
                
                Rectangle()
                    .onTapGesture {
                        updateImageIndex(increment: true)
                    }
            }
            .foregroundColor(.white.opacity(0.01))
        }
    }
}

private extension TinderEntry.Home.CardStack.Card.ImageScrollingOverlay {
    func updateImageIndex(increment: Bool) {
        if increment {
            guard currentImageIndex < imageCount - 1 else {
                return currentImageIndex = 0
            }
            currentImageIndex += 1
        } else {
            guard currentImageIndex > 0 else {
                return currentImageIndex = imageCount - 1
            }
            currentImageIndex -= 1
        }
    }
}

#Preview {
    TinderEntry.Home.CardStack.Card.ImageScrollingOverlay(currentImageIndex: .constant(0), imageCount: 2)
}
