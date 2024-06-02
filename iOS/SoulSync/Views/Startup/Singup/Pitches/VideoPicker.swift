//
//  VideoPicker.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/2/24.
//

import SwiftUI
import AVKit

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
