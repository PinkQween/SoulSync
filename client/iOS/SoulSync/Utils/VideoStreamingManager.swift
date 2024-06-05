//
//  VideoStreamingManager.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/5/24.
//

import AVKit

class VideoPlayerManager: ObservableObject {
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playerLayer: AVPlayerLayer?
    public var isPlaying: Bool = false
    public var userEmail: String = ""

    init(url: URL, authorizationToken: String) {
        let headers = ["Authorization": "Bearer \(authorizationToken)"]
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        self.playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        extractEmail(from: url, authorizationToken: authorizationToken)
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

        private func extractEmail(from url: URL, authorizationToken: String) {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "HEAD" // Only request headers

            URLSession.shared.dataTask(with: request) { [weak self] (_, response, error) in
                guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                    print("Failed to get headers: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                if let email = httpResponse.allHeaderFields["user"] as? String {
                    DispatchQueue.main.async {
                        self?.userEmail = email
                    }
                }

                dump(httpResponse)
                print("Internal print")
                print(self?.userEmail ?? "")
            }.resume()
        }
}
