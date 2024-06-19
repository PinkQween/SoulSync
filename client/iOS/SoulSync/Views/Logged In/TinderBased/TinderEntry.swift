//
//  TinderEntry.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI

struct TinderEntry: View {
    @StateObject var matchManager = MatchManager()
    
    var body: some View {
        MainTabBar()
            .environmentObject(matchManager)
    }
}

#Preview {
    TinderEntry()
}
