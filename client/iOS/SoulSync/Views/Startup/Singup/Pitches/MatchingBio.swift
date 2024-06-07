//
//  MatchingBio.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/5/24.
//

import SwiftUI
import AVFoundation

struct MatchingBio: View {
    let manager: PreviewVideoPlayerManager
    @State var overlay: Bool = false
    @Binding var addedBio: Bool
    @Binding var addedPitch: Bool
    @State private var bio: String = ""
    @State var video: URL
    @State private var isUploading: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                MatchingBioViewController(manager: manager)
                    .ignoresSafeArea()
                    .onAppear {
                        manager.play()
                    }
                    .onTapGesture {
                        manager.isPlaying ? manager.pause() : manager.play()
                        
                        withAnimation {
                            overlay.toggle()
                            
                            let seconds = 0.5
                            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                
                                withAnimation {
                                    overlay.toggle()
                                }
                            }
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
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    ZStack {
                        Capsule()
                            .fill(.black)
                        
                        Button {
                            addedPitch = false
                        } label: {
                            VStack {
                                Image(systemName: "arrowshape.backward.circle.fill")
                                    .padding(.top, 5)
                                
                                Spacer()
                            }
                            .padding()
                            .scaleEffect(1.5)
                        }
                    }
                    .frame(width: 40, height: 70)
                    .padding(20)
                    .padding(.bottom, -50)
                    
                    Spacer()
                    
                    ZStack {
                        Capsule()
                            .fill(.black)
                        
                        Button {
                            guard !isUploading else { return }
                            
                            uploadVideo()
                            
                            addedBio = true
                        } label: {
                            VStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .padding(.top, 5)
                                
                                Spacer()
                            }
                            .padding()
                            .scaleEffect(1.5)
                        }
                    }
                    .frame(width: 40, height: 70)
                    .padding(20)
                    .padding(.bottom, -50)
                }
                
                TextEditor(text: $bio)
                    .frame(height: 150)
                    .overlay {
                        if bio.isEmpty {
                            VStack {
                                HStack {
                                    Text("Bio...")
                                        .padding(8)
                                        .foregroundStyle(.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                        }
                    }
                //                    .border(Color.white)
            }
            .ignoresSafeArea(.container)
            
            //        VStack {
            //            HStack {
            //                Spacer()
            //
            //                Button {
            //                    addedBio.toggle()
            //                } label: {
            //                    Text("Done")
            //                        .padding()
            //                        .background(.black)
            //                        .cornerRadius(19.0)
            //                }
            //            }
            //            .padding(15)
            //            .padding(.top, -15)
            //
            //            Spacer()
            //        }
        }
        //        .frame(height: UIScreen.main.bounds.height)
        .overlay {
            if isUploading {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    
                    VStack {
                        ProgressView()
                            .scaleEffect(3)
                            .padding(50)
                        
                        Text("Uploading...")
                            .font(.title)
                    }
                }
            }
        }
        .onDisappear {
            manager.pause()
        }
    }
    
    func uploadVideo() {
        isUploading = true
        
//        compressVideo(inputURL: video, outputURL: getOutputURL()) { [self] compressedURL in
//            guard let compressedURL = compressedURL else {
//                print("Failed to compress video.")
//                self.isUploading = false
//                return
//            }
            
            do {
                let videoData = try Data(contentsOf: video)
                
                // Ensure the video data is under 100MB
//                guard videoData.count <= 100 * 1024 * 1024 else {
//                    print("Compressed video is larger than 100MB.")
//                    self.isUploading = false
//                    return
//                }
                
                let url = URL(string: "\(apiURL)/upload-pitch")!
                let headers = [
                    "Authorization": "Bearer \(KeychainManager.loadString(key: "token"))"
                ]
                
                NetworkManager.shared.upload(to: url, videoData: videoData, bio: bio, headers: headers) { data, response, error in
                    DispatchQueue.main.async {
                        self.isUploading = false
                    }
                    
                    if let error = error {
                        print("Error uploading video: \(error)")
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse {
                        print("Upload finished with status code: \(response.statusCode)")
                    }
                }
            } catch {
                print("Failed to load video data: \(error)")
                self.isUploading = false
//            }
        }
    }
    
    func getOutputURL() -> URL {
        let tempDir = NSTemporaryDirectory()
        let outputPath = (tempDir as NSString).appendingPathComponent("compressed.mp4")
        return URL(fileURLWithPath: outputPath)
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: inputURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            print("Unable to create AVAssetExportSession.")
            completion(nil)
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        
        // Ensure the output directory exists
        let outputDir = outputURL.deletingLastPathComponent()
        do {
            try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create output directory: \(error)")
            completion(nil)
            return
        }
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(outputURL)
            case .failed:
                if let error = exportSession.error {
                    print("Failed to export video: \(error.localizedDescription)")
                }
                completion(nil)
            case .cancelled:
                print("Video export cancelled.")
                completion(nil)
            default:
                print("Unknown export session status: \(exportSession.status.rawValue)")
                completion(nil)
            }
        }
    }
}

extension NetworkManager {
    func upload(to url: URL, videoData: Data, bio: String, headers: [String: String], completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let body = createBody(boundary: boundary, videoData: videoData, bio: bio)
        request.httpBody = body
        
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    private func createBody(boundary: String, videoData: Data, bio: String) -> Data {
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        // Add video data
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"video\"; filename=\"video.mp4\"\r\n".utf8))
        body.append(Data("Content-Type: video/mp4\r\n\r\n".utf8))
        body.append(videoData)
        body.append(Data("\r\n".utf8))
        
        // Add bio data
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"bio\"\r\n\r\n".utf8))
        body.append(Data("\(bio)\r\n".utf8))
        
        // Add the final boundary
        body.append(Data("--\(boundary)--\r\n".utf8))
        
        return body
    }
}

#Preview {
    MatchingBio(manager: PreviewVideoPlayerManager(url: Bundle.main.url(forResource: "video1", withExtension: "mp4")!), addedBio: .constant(false), addedPitch: .constant(true), video: Bundle.main.url(forResource: "video1", withExtension: "mp4")!)
        .preferredColorScheme(.dark)
}
