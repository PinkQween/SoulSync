//
//  NotificationServiceProtocol.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/20/24.
//

import UserNotifications
import UIKit

protocol NotificationServiceProtocol {
    func registerPushNotifications(delegate: UNUserNotificationCenterDelegate)
    func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data)
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error)
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
}
