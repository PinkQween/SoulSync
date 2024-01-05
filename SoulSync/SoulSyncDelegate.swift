//
//  PushNotify.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 1/5/24.
//

import UIKit
import UserNotifications
import PushKit

class SoulSyncDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("didFinishLaunchingWithOptions")
        registerPushNotifications()
        return true
    }
    
    //    MARK: Push Notification
    func registerPushNotifications(){
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: authOptions) { granted, error in
                
                print("Permission granted: \(granted)")
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("Successfully registered notification")
        let tokenParts = deviceToken.map{ data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register notification")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
        print(userInfo)
        
        
    }
    
}

extension SoulSyncDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("userNotificationCenter didReceive")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("userNotificationCenter willPresent")
        completionHandler(UNNotificationPresentationOptions(rawValue: 0));
    }
}
