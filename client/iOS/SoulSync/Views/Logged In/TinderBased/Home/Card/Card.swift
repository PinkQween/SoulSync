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
        @ObservedObject var viewModel: CardsViewModel
        //        @State private var manager: VideoPlayerManager = VideoPlayerManager(url: URL(string: "\(testingApiURL)/streaming/9:16")!, authorizationToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuZXdVc2VyIjp7InVzZXJuYW1lIjoiSGFubmEgU2thaXJpcGEiLCJiaXJ0aGRhdGUiOiIxMi8xMC8wOCIsImVtYWlsIjoiaGFubmFAaGFubmFza2FpcmlwYS5jb20iLCJoYXNoZWRQYXNzd29yZCI6IiQyYiQxMCRydzI0bzBzd1hrdHFYN0ZpT2FrODZlNXljZkhYMlJNeFN4S2I0ek1SUDdzaVpKV1dQanIuRyIsImNvZGUiOjUxMzUzNSwiZGV2aWNlSUQiOlsiMmE3OGM0ZmRlZTY1YmQ1NzBjNjYxY2U1Y2ZlNGQ2MzFhOGY3YjQwOWE2NzgyYmMzNzM1MjFhN2FjYTljZTBiZSJdLCJ2ZXJpZmllZCI6ZmFsc2UsInRlbXAiOnRydWUsImNyZWF0ZWRBdCI6MTcxNzU5NjE0NDI0N30sImlhdCI6MTcxNzU5NjE0NH0._T9XRScIQ2CNnk_8jOSDvfgehezpf4G2Qc6S4Tlfsmg")
        @State private var xOffset: CGFloat = 0
        @State private var degrees: Double = 0
        @State private var currentImageIndex = 0
        @State private var showProfileModel = false
        
        let model: CardModel
        
        var body: some View {
            ZStack(alignment: .bottom) {
                //#if targetEnvironment(simulator)
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
                //#else
                //                ZStack(alignment: .top) {
                //                    StreamingViewController(manager: manager)
                //                        .background(.primary)
                //                        .onAppear {
                //                            manager.play()
                //                        }
                //                        .onDisappear {
                //                            manager.pause()
                //                        }
                //
                //                    SwipeActionIndicator(xOffset: $xOffset)
                //                }
                //#endif
                
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
    
    struct StreamingViewController: UIViewControllerRepresentable {
        @ObservedObject var manager: VideoPlayerManager
        
        func makeUIViewController(context: Context) -> UIViewController {
            let viewController = UIViewController()
            if let playerLayer = manager.getPlayerLayer() {
                playerLayer.frame = viewController.view.bounds
                playerLayer.videoGravity = .resizeAspectFill
                viewController.view.layer.addSublayer(playerLayer)
            }
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            if let playerLayer = manager.getPlayerLayer() {
                playerLayer.frame = uiViewController.view.bounds
                playerLayer.videoGravity = .resizeAspectFill
            }
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
