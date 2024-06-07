//
//  PreviewVideoPlayerManager.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/5/24.
//

import AVKit

class PreviewVideoPlayerManager: ObservableObject {
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playerLayer: AVPlayerLayer?
    public var isPlaying: Bool = false
    
    init(url: URL) {
        let asset = AVURLAsset(url: url)
        self.playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    func play() {
        player?.play()
        self.isPlaying.toggle()
    }
    
    func pause() {
        player?.pause()
        self.isPlaying.toggle()
    }
    
    func getPlayerLayer() -> AVPlayerLayer? {
        if playerLayer == nil {
            playerLayer = AVPlayerLayer(player: player)
        }
        return playerLayer
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
