//
//  PitchCreator.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 1/9/24.
//

import SwiftUI
import AVFoundation
import Photos

struct CameraView: UIViewControllerRepresentable {
    @Binding var cameraPosition: AVCaptureDevice.Position
    var mirror: Bool
    var isRecording: Binding<Bool>
    var didFinishRecording: ((URL) -> Void)?

    class Coordinator: NSObject, AVCaptureFileOutputRecordingDelegate {
        var parent: CameraView
        var outputFileURL: URL?

        init(parent: CameraView) {
            self.parent = parent
        }

        // Implement camera switching and recording logic here if needed

        func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
            // Handle recording completion here if needed
            parent.isRecording.wrappedValue = false
            self.outputFileURL = outputFileURL

            // Pass the URL back to CameraView
            if let url = self.outputFileURL {
                parent.didFinishRecording?(url)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        return CameraViewController(coordinator: context.coordinator, cameraPosition: cameraPosition, mirror: mirror)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update logic if needed
    }
}

class CameraViewController: UIViewController {
    let coordinator: CameraView.Coordinator
    var cameraPosition: AVCaptureDevice.Position
    var mirror: Bool

    init(coordinator: CameraView.Coordinator, cameraPosition: AVCaptureDevice.Position, mirror: Bool) {
        self.coordinator = coordinator
        self.cameraPosition = cameraPosition
        self.mirror = mirror
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var captureSession: AVCaptureSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.captureSession = AVCaptureSession()

        guard let captureSession = self.captureSession else {
            print("Unable to create AVCaptureSession")
            return
        }

        do {
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: self.cameraPosition),
                  let audioDevice = AVCaptureDevice.default(for: .audio) else {
                print("Camera or microphone not available")
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

            let movieOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(movieOutput) {
                captureSession.addOutput(movieOutput)
                movieOutput.startRecording(to: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov"), recordingDelegate: coordinator)
            } else {
                print("Unable to add movie output to the session")
            }

            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill

            if self.mirror {
                previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
                previewLayer.connection?.isVideoMirrored = true
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
}

struct PitchCreatorView: View {
    @State private var cameraPosition: AVCaptureDevice.Position = .front
    @State private var mirrorCamera = true
    @State private var isRecording = false // Variable to track recording state
    
    var body: some View {
        ZStack {
            CameraView(cameraPosition: $cameraPosition, mirror: mirrorCamera, isRecording: $isRecording) { url in
                // Handle the recorded video URL here
                print("Recorded video URL:", url.absoluteString)
                
                // Save to photo library
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        PHPhotoLibrary.shared().performChanges {
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                        } completionHandler: { success, error in
                            if let error = error {
                                print("Error saving to photo library:", error.localizedDescription)
                            } else if success {
                                print("Video saved to photo library successfully.")
                            }
                        }
                    } else {
                        print("Permission to access the photo library denied.")
                    }
                }
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
                    Spacer()
                    Button(action: {
                        withAnimation {
                            // Toggle recording state
                            isRecording.toggle()
                        }
                    }) {
                        Image(systemName: isRecording ? "circle.fill" : "circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    PitchCreatorView()
        .preferredColorScheme(.dark)
}
