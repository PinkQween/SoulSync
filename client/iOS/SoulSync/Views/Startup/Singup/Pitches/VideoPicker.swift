//
//  VideoPicker.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/2/24.
//

import SwiftUI
import Photos
import AVKit

struct CustomVideoPicker: View {
    @Binding var selectedVideoURL: URL?
    var completionHandler: ((URL?) -> Void)
    
    @State private var videos: [PHAsset] = []
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(videos, id: \.self) { video in
                    VideoThumbnail(video: video, didSelectVideo: { self.fetchVideoURL(for: video) })
                }
            }
            .padding()
            .padding(.vertical, 40)
        }
        .onAppear {
            self.fetchVideos()
        }
    }
    
    private func fetchVideos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        fetchResult.enumerateObjects { asset, _, _ in
            if asset.duration <= 60 { // Check if duration is under 1 minute
                self.videos.insert(asset, at: 0)
            }
        }
    }
    
    private func fetchVideoURL(for asset: PHAsset) {
        let requestOptions = PHVideoRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        PHImageManager.default().requestAVAsset(forVideo: asset, options: requestOptions) { avAsset, _, _ in
            if let urlAsset = avAsset as? AVURLAsset {
                DispatchQueue.main.async {
                    self.selectedVideoURL = urlAsset.url
                    self.completionHandler(urlAsset.url)
                }
            }
        }
    }
    
    
}

struct VideoThumbnail: View {
    let video: PHAsset
    let didSelectVideo: () -> Void
    
    @State private var thumbnailImage: UIImage?
    
    var body: some View {
        VStack {
            if let image = thumbnailImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .onAppear {
                        self.fetchThumbnail()
                    }
                    .onTapGesture {
                        self.didSelectVideo()
                    }
            } else {
                // Placeholder image or loading indicator
                Color.gray
                    .frame(width: 100, height: 100)
            }
            
            if let duration = formattedDuration(video.duration) {
                Text(duration)
            }
        }
        .onAppear {
            fetchThumbnail()
        }
    }
    
    private func formattedDuration(_ duration: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: duration)
    }
    
    private func fetchThumbnail() {
        let targetSize = CGSize(width: 500, height: 500)
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .fastFormat
        options.resizeMode = .exact
        
        PHImageManager.default().requestImage(for: video, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            if let image = image {
                self.thumbnailImage = image
            }
        }
    }
    
}

#Preview {
    CustomVideoPicker(selectedVideoURL: .constant(nil)) { url in
        return
    }
    .preferredColorScheme(.dark)
}
