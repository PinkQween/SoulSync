//
//  TinderEntry.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI

struct TinderEntry: View {
    @StateObject var matchManager = MatchManager(service: MockMatchService())
    
    var body: some View {
        Auth()
            .environmentObject(matchManager)
    }
}

#Preview {
    TinderEntry()
}
