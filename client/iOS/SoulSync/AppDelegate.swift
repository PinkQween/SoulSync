//
//  AppDelegate.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/20/24.
//

import FirebaseCore
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let notificationService: NotificationServiceProtocol
    public var deviceIDProvider: DeviceIDProvider
    
    override init() {
        self.notificationService = NotificationService()
        self.deviceIDProvider = DeviceIDProvider()
        super.init()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("didFinishLaunchingWithOptions")
        notificationService.registerPushNotifications(delegate: self)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationService.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
        
        // Update device ID in DeviceIDProvider
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        deviceIDProvider.deviceID = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        notificationService.didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        notificationService.didReceiveRemoteNotification(userInfo: userInfo, fetchCompletionHandler: completionHandler)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        notificationService.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        notificationService.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
    }
}
