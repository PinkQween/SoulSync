//
//  CameraController.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/2/24.
//

import UIKit
import AVFoundation

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
