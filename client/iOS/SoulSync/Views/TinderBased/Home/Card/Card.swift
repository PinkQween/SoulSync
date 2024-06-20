//
//  Card.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI
import AVKit

extension TinderEntry.Home.CardStack {
    struct Card: View {
        @EnvironmentObject var matchManager: MatchManager
        @StateObject var viewModel: CardsViewModel
        @State private var xOffset: CGFloat = 0
        @State private var degrees: Double = 0
        @State private var currentImageIndex = 0
        @State private var showProfileModel = false
        
        let model: CardModel
        
        var body: some View {
            ZStack(alignment: .bottom) {
                ZStack(alignment: .top) {
                    Image(user.profileImages[currentImageIndex])
                        .resizable()
                        .scaledToFill()
                        .overlay {
                            ImageScrollingOverlay(currentImageIndex: $currentImageIndex, imageCount: imageCount)
                        }
                        .background(.primary)
                        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    CardImageIndicator(currentImageIndex: currentImageIndex, imageCount: imageCount)
                    
                    SwipeActionIndicator(xOffset: $xOffset)
                }
                
                CardUserInfo(user: user, showProfileModel: $showProfileModel)
            }
            .fullScreenCover(isPresented: $showProfileModel) {
                UserProfileView(user: user)
            }
            .onReceive(viewModel.$buttonSwipeAction, perform: { action in
                onReciveSwipeAction(action)
            })
            .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(x: xOffset)
            .rotationEffect(.degrees(degrees))
            .animation(.snappy, value: xOffset)
            .gesture(
                DragGesture()
                    .onChanged(onDragChange)
                    .onEnded(onDragEnded)
            )
        }
    }
}

private extension TinderEntry.Home.CardStack.Card {
    var user: User {
        return model.user
    }
    
    var imageCount: Int {
        return user.profileImages.count
    }
}

private extension TinderEntry.Home.CardStack.Card {
    func returnToCenter() {
        xOffset = 0
        degrees = 0
    }
    
    func swipeRight() {
        withAnimation {
            xOffset = 500
            degrees = 500 / 25
        } completion: {
            viewModel.removeCard(model)
            matchManager.checkForMatch(withUser: user)
        }
    }
    
    func swipeLeft() {
        withAnimation {
            xOffset = -500
            degrees = -500 / 25
        } completion: {
            viewModel.removeCard(model)
        }
    }
    
    func onReciveSwipeAction(_ action: SwipeActions?) {
        guard let action else { return }
        
        let topCard = viewModel.cardModels.last
        
        if topCard == model {
            switch (action) {
                case .reject:
                    swipeLeft()
                case .like:
                    swipeRight()
            }
        }
    }
}

private extension TinderEntry.Home.CardStack.Card {
    func onDragChange(_ value: _ChangedGesture<DragGesture>.Value) {
        xOffset = value.translation.width
        degrees = Double(xOffset / 25)
    }
    
    func onDragEnded(_ value: _ChangedGesture<DragGesture>.Value) {
        let width = value.translation.width
        
        if abs(width) <= abs(SizeConstants.screenCutOff) {
            returnToCenter()
        } else if width >= SizeConstants.screenCutOff {
            swipeRight()
        } else {
            swipeLeft()
        }
    }
}

#Preview {
    TinderEntry.Home.CardStack.Card(viewModel: CardsViewModel(service: CardService()), model: .init(user: .init(
        id: NSUUID().uuidString,
        fullname: "Megan Fox",
        age: 38,
        profileImages: [
            "megan-fox-1",
            "megan-fox-2",
        ]
    )))
    //        .preferredColorScheme(.dark)
}
