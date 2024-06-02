//
//  SoulSyncApp.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 11/27/23.
//

import SwiftUI

@main
struct SoulSyncApp: App {
    @UIApplicationDelegateAdaptor private var delugate: SoulSyncDelegate
    
    var body: some Scene {
        WindowGroup {
            PitchCreatorView()
                .preferredColorScheme(.dark)
        }
    }
    
    init() {
            // Check if the device is jailbroken
            if JailbreakDetection.isJailbroken() {
                // If jailbroken, show an alert and terminate the app
                showAlertAndExit()
            }
        }
        
        func showAlertAndExit() {
            let alert = UIAlertController(title: "Device Jailbroken", message: "This app cannot run on jailbroken devices.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                // Terminate the app upon user confirmation
                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            }))
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        }
}
