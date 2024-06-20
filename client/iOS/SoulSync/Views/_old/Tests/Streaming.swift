//
//  Streaming.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/5/24.
//

import SwiftUI

struct TEST_STREAMING: View {
    let manager: VideoPlayerManager = VideoPlayerManager(url: URL(string: "\(testingApiURL)/streaming")!, authorizationToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuZXdVc2VyIjp7InVzZXJuYW1lIjoiSGFubmEgU2thaXJpcGEiLCJiaXJ0aGRhdGUiOiIxMi8xMC8wOCIsImVtYWlsIjoiaGFubmFAaGFubmFza2FpcmlwYS5jb20iLCJoYXNoZWRQYXNzd29yZCI6IiQyYiQxMCRydzI0bzBzd1hrdHFYN0ZpT2FrODZlNXljZkhYMlJNeFN4S2I0ek1SUDdzaVpKV1dQanIuRyIsImNvZGUiOjUxMzUzNSwiZGV2aWNlSUQiOlsiMmE3OGM0ZmRlZTY1YmQ1NzBjNjYxY2U1Y2ZlNGQ2MzFhOGY3YjQwOWE2NzgyYmMzNzM1MjFhN2FjYTljZTBiZSJdLCJ2ZXJpZmllZCI6ZmFsc2UsInRlbXAiOnRydWUsImNyZWF0ZWRBdCI6MTcxNzU5NjE0NDI0N30sImlhdCI6MTcxNzU5NjE0NH0._T9XRScIQ2CNnk_8jOSDvfgehezpf4G2Qc6S4Tlfsmg")
    @State var overlay: Bool = false
    
    var body: some View {
        TEST_STREAMINGViewController(manager: manager)
            .ignoresSafeArea()
            .onAppear(perform: {
                manager.play()
                dump("Printing")
                dump(manager.userEmail)
            })
            .onTapGesture {
                manager.isPlaying ? manager.pause() : manager.play()
                overlay.toggle()
                let seconds = 0.75
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    overlay.toggle()
                }
            }
            .overlay {
                if (overlay) {
                    ZStack {
                        Circle()
                            .foregroundStyle(.black)
                            .opacity(0.4)
                        
                        Image(systemName: !manager.isPlaying ? "pause.fill" : "play.fill")
                    }
                    .frame(width: 50, height: 50)
                    .scaleEffect(2.25)
                }
            }
    }
}

struct TEST_STREAMINGViewController: UIViewControllerRepresentable {
    @ObservedObject var manager: VideoPlayerManager

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        if let playerLayer = manager.getPlayerLayer() {
            playerLayer.frame = viewController.view.bounds
            viewController.view.layer.addSublayer(playerLayer)
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let playerLayer = manager.getPlayerLayer() {
            playerLayer.frame = uiViewController.view.bounds
        }
    }
}

#Preview {
    TEST_STREAMING()
        .preferredColorScheme(.dark)
}
