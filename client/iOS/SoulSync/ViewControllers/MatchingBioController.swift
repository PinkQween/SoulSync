//
//  MatchingBioController.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/5/24.
//

import SwiftUI

struct MatchingBioViewController: UIViewControllerRepresentable {
    @ObservedObject var manager: PreviewVideoPlayerManager

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        // Ensure the player layer fills the view
        if let playerLayer = manager.getPlayerLayer() {
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = viewController.view.bounds
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
