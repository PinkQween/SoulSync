//
//  NewMatches.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/18/24.
//

import SwiftUI

extension TinderEntry.Messages {
    struct NewMatches: View {
        @EnvironmentObject var matchManager: MatchManager
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("New Matches")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        if matchManager.matches.isEmpty {
                            ForEach(0..<5) { index in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.secondarySystemBackground))
                                    .frame(width: 96, height: 120)
                            }
                        } else {
                            ForEach(matchManager.matches) { match in
                                NewMatchItem(match: match)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .task {
                await matchManager.fetchMatches()
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .padding(.horizontal, 8)
            .padding(.top)
        }
    }
}

#Preview {
    TinderEntry.Messages.NewMatches()
        .environmentObject(MatchManager(service: MockMatchService()))
}
