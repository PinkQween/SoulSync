//
//  NotifacationService.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/20/24.
//

import UIKit
import UserNotifications

class NotificationService: NotificationServiceProtocol {

    func registerPushNotifications(delegate: UNUserNotificationCenterDelegate) {
        UNUserNotificationCenter.current().delegate = delegate
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            print("Permission granted: \(granted)")

            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        print("Successfully registered notification")
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print(token)
        UserDefaults.standard.set(token, forKey: "deviceToken")
    }

    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        print("Failed to register notification")
    }

    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
        print(userInfo)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter didReceive")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("userNotificationCenter willPresent")
        completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }
}
