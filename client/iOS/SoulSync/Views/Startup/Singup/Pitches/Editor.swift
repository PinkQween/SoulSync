//
//  Editor.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/2/24.
//

import SwiftUI
import AVKit

struct editorView: View {
    @State var videoURL: URL?
    
    var body: some View {
        ZStack {
            let player = AVPlayer(url: videoURL!)
            VideoPlayer(player: player)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    editorView(videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
}
