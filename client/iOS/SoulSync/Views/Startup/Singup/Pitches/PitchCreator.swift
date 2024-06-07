//
//  PitchCreator.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 1/9/24.
//

import SwiftUI
import AVFoundation
import Photos

struct PitchCreatorView: View {
    @Binding var addedPitch: Bool
    @State private var cameraPosition: AVCaptureDevice.Position = .front
    @State private var mirrorCamera = false
    @State private var mirrorRecording = true
    @State private var isRecording = false
    @State private var isPickerPresented = false
    @State private var lastVideoThumbnail: UIImage?
    @State private var orientationChange = false
    @State private var selectedVideoURL: URL?
    @State private var isVideoSelected = false
    @State private var editorViewIsActive = false
    @Binding var pitchURL: URL?
    
    @State private var recordingTimer: Timer?
    @State private var recordingDuration: TimeInterval = 60
    
    var body: some View {
        ZStack {
            CameraView(cameraPosition: $cameraPosition, mirror: mirrorRecording, previewMirror: mirrorCamera, isRecording: $isRecording) { url in
                print("Recorded video URL:", url.absoluteString)
                
                selectedVideoURL = url
                isVideoSelected = true
                
                // MARK: URL -> lib
//                                // Save to photo library
//                                PHPhotoLibrary.requestAuthorization { status in
//                                    if status == .authorized {
//                                        PHPhotoLibrary.shared().performChanges {
//                                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
//                                        } completionHandler: { success, error in
//                                            DispatchQueue.main.async {
//                                                if let error = error {
//                                                    print("Error saving to photo library:", error.localizedDescription)
//                                                } else if success {
//                                                    print("Video saved to photo library successfully.")
//                                                } else {
//                                                    print("Unknown error occurred while saving to photo library.")
//                                                }
//                                            }
//                                        }
//                                    } else {
//                                        print("Permission to access the photo library denied.")
//                                    }
//                                }
            }
            .id(orientationChange)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                // Toggle the orientationChange state to force a redraw
                self.orientationChange.toggle()
            }
            .edgesIgnoringSafeArea(.all)
            .background(
                Group {
                    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                        Image("PREVIEW_camera")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    }
                }
            )
            
            VStack {
                Spacer()
                
                HStack {
                    if lastVideoThumbnail != nil {
                        Button(action: {
                            self.isPickerPresented.toggle()
                        }) {
                            ZStack {
                                if let thumbnail = lastVideoThumbnail {
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white, lineWidth: 5)
                                        )
                                } else {
                                    Image("NoVideoThumbnailReplacement")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white, lineWidth: 5)
                                        )
                                }
                            }
                        }
                        .padding()
                        .fullScreenCover(isPresented: $isPickerPresented, content: {
                            CustomVideoPicker(selectedVideoURL: $selectedVideoURL) { url in
                                if let url = url {
                                    selectedVideoURL = url
                                    isVideoSelected = true
                                    isPickerPresented = false
                                    pitchURL = selectedVideoURL
                                    addedPitch.toggle()
                                }
                            }
                            .background(Color.black)
                            .ignoresSafeArea()
                        })
                    }
                    
                    Spacer()
                    Button(action: {
                        withAnimation {
                            // Toggle recording state
                            isRecording.toggle()
                            
                            // Call the startRecording method when the button is pressed
                            // Call the startRecording method when the button is pressed
                            
#if targetEnvironment(simulator)
                            if !isRecording {
                                pitchURL = Bundle.main.url(forResource: "video1", withExtension: "mp4")
                                addedPitch.toggle()
                            }
#else
                            if isRecording {
                                CameraViewController.cameraViewController?.startRecording()
                                        
                                        // Start a timer to stop recording after 60 seconds
                                        recordingTimer = Timer.scheduledTimer(withTimeInterval: recordingDuration, repeats: false) { _ in
                                            isRecording.toggle()
                                            pitchURL = CameraViewController.cameraViewController?.stopRecording()
                                            addedPitch.toggle()
                                        }
                            } else {
                                // Call the stopRecording method when the button is pressed to stop recording
                                pitchURL = CameraViewController.cameraViewController?.stopRecording()
                                addedPitch.toggle()
                            }
#endif
                        }
                    }) {
                        Image(systemName: isRecording ? "circle.fill" : "circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, lastVideoThumbnail == nil ? 0 : 85.0)
                    
                    Spacer()
                }
                .padding(.bottom, 25.0)
                .padding(.leading, 15.0)
            }.onAppear {
                self.loadLastVideoThumbnail()
            }
            .onChange(of: isVideoSelected) { _, newValue in
                print("isVideoSelected changed to \(newValue)")
                if newValue {
                    withAnimation {
                        editorViewIsActive = true
                    }
                }
            }
        }
    }
    
    // Load the last video thumbnail from the camera roll
    private func loadLastVideoThumbnail() {
        // Load the last video thumbnail from the camera roll using PHAsset
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        
        guard let lastVideo = fetchResult.firstObject else {
            // No video found, use custom picture or handle accordingly
            return
        }
        
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: lastVideo, targetSize: CGSize(width: 55, height: 55), contentMode: .aspectFill, options: nil) { (image, _) in
            if let thumbnail = image {
                self.lastVideoThumbnail = thumbnail
            }
        }
    }
}


#Preview {
    PitchCreatorView(addedPitch: .constant(false), pitchURL: .constant(nil))
        .preferredColorScheme(.dark)
}
