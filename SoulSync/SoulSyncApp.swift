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
            FirstLaunchView()
                .preferredColorScheme(.dark)
        }
    }
}
