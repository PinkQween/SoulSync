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
//            FirstLaunchFAKEView(selectedTab: 1, isSignUpSuccessful: true, isLoginSuccessful: false, isCompleteSignUp: true, email: "hanna_boone@icloud.com", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuZXdVc2VyIjp7InVzZXJuYW1lIjoiSGFubmEgU2thaXJpcGEiLCJiaXJ0aGRhdGUiOiIwNy8xMC8wOCIsImVtYWlsIjoiaGFubmFfYm9vbmVAaWNsb3VkLmNvbSIsImhhc2hlZFBhc3N3b3JkIjoiJDJiJDEwJGQySDF0Y3N3OXEuSFFJNHloRUFuUi5sNTluM3p5TjFtYWVNLlIvVm52eGQ3YW8vVVQ5U0lXIiwiY29kZSI6MTIyNDc5LCJkZXZpY2VJRCI6WyIyYTc4YzRmZGVlNjViZDU3MGM2NjFjZTVjZmU0ZDYzMWE4ZjdiNDA5YTY3ODJiYzM3MzUyMWE3YWNhOWNlMGJlIl0sInZlcmlmaWVkIjpmYWxzZSwidGVtcCI6dHJ1ZSwiY3JlYXRlZEF0IjoxNzE3NzY1MzQxNzU5fSwiaWF0IjoxNzE3NzY1MzQxfQ.rjQe86ZwDg1yHmm-nisrhXMyO1ak261W7jZatEjdSfY", addedDetails: true, addedPreferences: true, addedPitch: false, addedBio: false, isSwipeable: true, pitchURL: Bundle.main.url(forResource: "video1", withExtension: "mp4"))
//            CheckLoginStatus()
//                .preferredColorScheme(.dark)
            TinderEntry()
                .onOpenURL { url in
                                    print(url)
                                }
        }
    }
    
    init() {
            // Check if the device is jailbroken
            if JailbreakDetection.isJailbroken() {
                // If jailbroken, show an alert and terminate the app
                print("Jailbroken")
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
