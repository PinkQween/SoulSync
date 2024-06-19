//  MessagesViewController.swift
//  SoulSync iMessage extension
//
//  Created by Hanna Skairipa on 6/14/24.
//

import UIKit
import SwiftUI
import Messages

class MessagesViewController: MSMessagesAppViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        
        // Use a UIHostingController as window root view controller.
        let hostingController = UIHostingController(rootView: contentView)
        
        // Add the SwiftUI view to the view controller hierarchy.
        addChild(hostingController)
        hostingController.view.frame = self.view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

// A SwiftUI view that integrates a sticker browser.
struct ContentView: View {
    var body: some View {
        VStack {
            Text("SoulSync Messages")
                .font(.largeTitle)
                .padding()
            
            // Integrate the Sticker Browser View
            StickerBrowserView()
        }
    }
}

// A UIViewControllerRepresentable to integrate MSStickerBrowserViewController into SwiftUI
struct StickerBrowserView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> MSStickerBrowserViewController {
        let stickerBrowserViewController = MSStickerBrowserViewController(stickerSize: .regular)
        return stickerBrowserViewController
    }
    
    func updateUIViewController(_ uiViewController: MSStickerBrowserViewController, context: Context) {
        // Configure the sticker browser
        uiViewController.stickerBrowserView.backgroundColor = .black
        uiViewController.stickerBrowserView.dataSource = context.coordinator
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, MSStickerBrowserViewDataSource {
        var stickers: [MSSticker] = []

        override init() {
            super.init()
            loadStickers()
        }

        func loadStickers() {
            // Initialize an empty array to hold the stickers
            var stickers = [MSSticker]()
            
            // Get all paths of resources in the main bundle
            let resourcePaths = Bundle.main.paths(forResourcesOfType: nil, inDirectory: nil)
            
            // Supported sticker file extensions
            let supportedExtensions = ["png", "apng", "gif"]
            
            // Iterate over all resource paths
            for path in resourcePaths {
                dump(path)
                // Get the file name and extension
                let fileName = (path as NSString).lastPathComponent
                let fileExtension = (fileName as NSString).pathExtension.lowercased()
                
                // Check if the file extension is in the list of supported extensions
                if supportedExtensions.contains(fileExtension) {
                    // Create the MSSticker object
                    if let url = Bundle.main.url(forResource: (fileName as NSString).deletingPathExtension, withExtension: fileExtension) {
                        if let sticker = try? MSSticker(contentsOfFileURL: url, localizedDescription: fileName) {
                            stickers.append(sticker)
                        }
                    }
                }
            }
            
            // Use the stickers array as needed
            print("Loaded \(stickers.count) stickers")
        }
        
        func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
            return stickers.count
        }

        func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
            return stickers[index]
        }
    }
}
