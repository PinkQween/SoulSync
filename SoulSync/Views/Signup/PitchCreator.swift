//
//  PitchCreator.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 1/9/24.
//

import SwiftUI
import AVFoundation
import Photos
import AVKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var cameraPosition: AVCaptureDevice.Position
    var mirror: Bool
    var previewMirror: Bool
    @Binding var isRecording: Bool
    var didFinishRecording: ((URL) -> Void)? // Trailing closure property
    
    init(cameraPosition: Binding<AVCaptureDevice.Position>, mirror: Bool, previewMirror: Bool, isRecording: Binding<Bool>, didFinishRecording: ((URL) -> Void)? = nil) {
        _cameraPosition = cameraPosition
        self.mirror = mirror
        self.previewMirror = previewMirror
        _isRecording = isRecording // Assign the binding directly
        self.didFinishRecording = didFinishRecording // Assign the closure to the property
    }
    
    class Coordinator: NSObject, AVCaptureFileOutputRecordingDelegate {
        var parent: CameraView
        var outputFileURL: URL?
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
            parent.$isRecording.wrappedValue = false // Use parent.isRecording.wrappedValue
            self.outputFileURL = outputFileURL
            
            if let url = self.outputFileURL {
                parent.didFinishRecording?(url) // Execute the trailing closure
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let cameraViewController = CameraViewController(coordinator: context.coordinator, cameraPosition: cameraPosition, mirror: mirror, previewMirror: previewMirror, didFinishRecording: didFinishRecording)
        CameraViewController.cameraViewController = cameraViewController
        
        cameraViewController.updateOrientation()
        
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
            cameraViewController.updateOrientation()
        }
        
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update logic if needed
    }
    
    func stopRecording() {
        CameraViewController.cameraViewController?.stopRecording()
    }
}

class CameraViewController: UIViewController {
    static var cameraViewController: CameraViewController? // Static property to store the CameraViewController instance
    
    let coordinator: CameraView.Coordinator
    var cameraPosition: AVCaptureDevice.Position
    var mirror: Bool
    var previewMirror: Bool
    
    var captureSession: AVCaptureSession?
    var movieOutput: AVCaptureMovieFileOutput?
    var didFinishRecording: ((URL) -> Void)?
    
    init(coordinator: CameraView.Coordinator, cameraPosition: AVCaptureDevice.Position, mirror: Bool, previewMirror: Bool, didFinishRecording: ((URL) -> Void)?) {
        self.coordinator = coordinator
        self.cameraPosition = cameraPosition
        self.mirror = mirror
        self.previewMirror = previewMirror
        self.didFinishRecording = didFinishRecording // Pass the callback here
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the initial orientation
        updateOrientation()
        
        self.captureSession = AVCaptureSession()
        
        guard let captureSession = self.captureSession else {
            print("Unable to create AVCaptureSession")
            return
        }
        
        do {
            let deviceType: AVCaptureDevice.DeviceType
            if self.cameraPosition == .front {
                deviceType = .builtInWideAngleCamera
            } else {
                deviceType = .builtInWideAngleCamera // Change this if using a different camera type
            }
            
            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [deviceType], mediaType: .video, position: self.cameraPosition).devices
            guard let videoDevice = devices.first else {
                print("Video device not available")
                return
            }
            
            guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
                print("Audio device not available")
                return
            }
            
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            
            if captureSession.canAddInput(videoInput) && captureSession.canAddInput(audioInput) {
                captureSession.addInput(videoInput)
                captureSession.addInput(audioInput)
            } else {
                print("Unable to add video or audio input to the session")
            }
            
            self.movieOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(self.movieOutput!) {
                captureSession.addOutput(self.movieOutput!)
            } else {
                print("Unable to add movie output to the session")
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            
            if self.previewMirror {
                if let connection = previewLayer.connection, connection.isVideoMirroringSupported {
                    connection.automaticallyAdjustsVideoMirroring = false
                    connection.isVideoMirrored = false
                }
            }
            
            previewLayer.frame = self.view.layer.bounds
            self.view.layer.addSublayer(previewLayer)
            
            // Start the session on the main thread
            DispatchQueue.global(qos: .background).async {
                captureSession.startRunning()
                print("Capture session started.")
            }
        } catch {
            print("Error setting up camera or microphone input: \(error.localizedDescription)")
        }
    }
    
    func updateOrientation() {
        print("update")
        
        guard let previewLayer = view.layer.sublayers?.first as? AVCaptureVideoPreviewLayer else { return }
        
        if let connection = previewLayer.connection {
            let orientation = UIDevice.current.orientation
            var rotationAngle: CGFloat = 0.0
            
            dump(orientation)
            
            switch orientation {
            case .portrait:
                rotationAngle = 90.0
            case .landscapeRight:
                rotationAngle = 0.0
            case .landscapeLeft:
                rotationAngle = 180.0
            case .portraitUpsideDown:
                rotationAngle = 270.0
            default:
                rotationAngle = 90.0
            }
            
            if connection.isVideoRotationAngleSupported(rotationAngle) {
                connection.videoRotationAngle = rotationAngle
            }
        }
    }
    
    func startRecording() {
        guard let movieOutput = self.movieOutput else {
            print("Movie output not available")
            return
        }
        
        // Update file type to mp4
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
        
        if let connection = movieOutput.connection(with: .video) {
                    connection.preferredVideoStabilizationMode = .auto
                    connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue) ?? .portrait

                    if self.mirror {
                        connection.automaticallyAdjustsVideoMirroring = false
                        connection.isVideoMirrored = false
                    }
                }
        
        movieOutput.startRecording(to: outputURL, recordingDelegate: coordinator)
        
        print("Recording started. Output URL:", outputURL.absoluteString)
        
        // Set mirror to false when recording starts
        self.mirror = false
    }
    
    func stopRecording() {
        guard let movieOutput = self.movieOutput else {
            print("Movie output not available")
            return
        }
        
        if movieOutput.isRecording {
            movieOutput.stopRecording()
            print("Recording stopped.")
        }
    }
    
}

struct PitchCreatorView: View {
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
    
    
    var body: some View {
        ZStack {
            if editorViewIsActive {
                editorView(videoURL: selectedVideoURL)
            } else {
                CameraView(cameraPosition: $cameraPosition, mirror: mirrorRecording, previewMirror: mirrorCamera, isRecording: $isRecording) { url in
                    print("Recorded video URL:", url.absoluteString)
                    
                    selectedVideoURL = url
                    isVideoSelected = true
                    
                    // MARK: URL -> lib
                    //                // Save to photo library
                    //                PHPhotoLibrary.requestAuthorization { status in
                    //                    if status == .authorized {
                    //                        PHPhotoLibrary.shared().performChanges {
                    //                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                    //                        } completionHandler: { success, error in
                    //                            DispatchQueue.main.async {
                    //                                if let error = error {
                    //                                    print("Error saving to photo library:", error.localizedDescription)
                    //                                } else if success {
                    //                                    print("Video saved to photo library successfully.")
                    //                                } else {
                    //                                    print("Unknown error occurred while saving to photo library.")
                    //                                }
                    //                            }
                    //                        }
                    //                    } else {
                    //                        print("Permission to access the photo library denied.")
                    //                    }
                    //                }
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
                                if isRecording {
                                    CameraViewController.cameraViewController?.startRecording()
                                } else {
                                    // Call the stopRecording method when the button is pressed to stop recording
                                    CameraViewController.cameraViewController?.stopRecording()
                                }
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

struct CustomVideoPicker: UIViewControllerRepresentable {
    @Binding var selectedVideoURL: URL?
    var completionHandler: ((URL?) -> Void)
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CustomVideoPicker
        
        init(parent: CustomVideoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let videoURL = info[.mediaURL] as? URL {
                parent.selectedVideoURL = videoURL
                parent.completionHandler(videoURL) // Pass the selected URL to the completion handler
            } else {
                parent.completionHandler(nil)
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update logic if needed
    }
}

struct editorView: View {
    @State var videoURL: URL?
    
    var body: some View {
        ZStack {
            let player = AVPlayer(url: videoURL!)
            VideoPlayer(player: player)
        }
    }
}

#Preview {
    PitchCreatorView()
        .preferredColorScheme(.dark)
}
