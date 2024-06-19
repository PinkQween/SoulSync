//
//  MainTabBar.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI

extension TinderEntry {
    struct MainTabBar: View {
        var body: some View {
            TabView {
                Home()
                    .tabItem {
                        Image(systemName: "heart")
                    }
                    .tag(0)
                
                Text("Search View")
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }
                    .tag(1)
                
                Text("Inbox View")
                    .tabItem {
                        Image(systemName: "bubble.left.and.text.bubble.right")
                    }
                    .tag(2)
                
                Profile(user: MockData.users[0])
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(3)
            }
            .tint(.primary)
        }
    }
}

#Preview {
    TinderEntry.MainTabBar()
}
