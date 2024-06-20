//
//  TinderEntry.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI

struct TinderEntry: View {
    @StateObject var matchManager = MatchManager(service: MockMatchService())
    @StateObject var authManager = AuthManager(service: MockAuthService())
    
    var body: some View {
        Group {
            switch authManager.authState {
                case .unauthenticated:
                    Auth()
                case .authenticated:
                    MainTabBar()
                        .environmentObject(matchManager)
            }
        }
        .environmentObject(authManager)
    }
}

#Preview {
    TinderEntry()
}
