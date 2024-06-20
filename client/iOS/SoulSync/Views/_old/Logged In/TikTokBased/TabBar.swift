//
//  TabBar.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/15/24.
//

import SwiftUI

extension TikTokEntry {
    struct TabBar: View {
        @State private var selectedTab: Int = 0
        
        var body: some View {
            TabView(selection: $selectedTab) {
                Feed()
                    .tabItem {
                        VStack {
                            Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                                .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                            //                            .environment(\.symbolVariants, .none)
                            Text("Home")
                        }
                    }
                    .onAppear {
                        selectedTab = 0
                    }
                    .tag(0)
                
                Text("Messages")
                    .tabItem {
                        VStack {
                            Image(systemName: selectedTab == 1 ? "message.fill" : "message")
                                .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                            Text("Messages")
                        }
                    }
                    .onAppear {
                        selectedTab = 1
                    }
                    .tag(1)
                
                Text("Profile")
                    .tabItem {
                        VStack {
                            Image(systemName: selectedTab == 2 ? "gearshape.fill" : "gearshape")
                                .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                            Text("Profile")
                        }
                    }
                    .onAppear {
                        selectedTab = 2
                    }
                    .tag(2)
            }
            .tint(.white)
        }
    }
}

#Preview {
    TikTokEntry.TabBar()
        .preferredColorScheme(.dark)
}
