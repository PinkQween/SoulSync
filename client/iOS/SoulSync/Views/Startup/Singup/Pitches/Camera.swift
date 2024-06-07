//
//  Camera.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/2/24.
//

import SwiftUI
import AVFoundation

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
    
    func stopRecording() -> URL? {
        return CameraViewController.cameraViewController?.stopRecording()
    }
}
