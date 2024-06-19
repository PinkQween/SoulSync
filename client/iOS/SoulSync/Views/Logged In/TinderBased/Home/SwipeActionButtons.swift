//
//  SwipeActionButtons.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/18/24.
//

import SwiftUI

extension TinderEntry.Home.CardStack {
    struct SwipeActionButtons: View {
        @StateObject var viewModel: CardsViewModel
        
        var body: some View {
            HStack(spacing: 32) {
                SwipeButton(image: "xmark", color: .red) {
                    viewModel.buttonSwipeAction = .reject
                }
                
                
                SwipeButton(image: "heart.fill", color: .green) {
                    viewModel.buttonSwipeAction = .like
                }
            }
        }
    }
}

private extension TinderEntry.Home.CardStack.SwipeActionButtons {
    struct SwipeButton: View {
        let image: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button {
                action()
            } label: {
                Image(systemName: image)
                    .fontWeight(.heavy)
                    .foregroundStyle(color)
                    .background {
                        Circle()
                            .fill(.white)
                            .frame(width: 48, height: 48)
                            .shadow(color: .gray.opacity(0.2), radius: 6)
                    }
            }
            .frame(width: 48, height: 48)
        }
    }
}

#Preview {
    TinderEntry.Home.CardStack.SwipeActionButtons(viewModel: CardsViewModel(service: CardService()))
}

#Preview {
    TinderEntry()
}
