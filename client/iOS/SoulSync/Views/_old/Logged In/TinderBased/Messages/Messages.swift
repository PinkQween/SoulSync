//
//  Messages.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/18/24.
//

import SwiftUI

extension TinderEntry {
    struct Messages: View {
        var body: some View {
            NavigationStack {
                List {
                    NewMatches()
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Matches")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    ZStack {
        TinderEntry.Messages()
    }
    .environmentObject(MatchManager(service: MockMatchService()))
}
