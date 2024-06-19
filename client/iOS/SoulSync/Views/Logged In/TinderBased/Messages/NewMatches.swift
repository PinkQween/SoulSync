//
//  NewMatches.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/18/24.
//

import SwiftUI

extension TinderEntry.Messages {
    struct NewMatches: View {
        var body: some View {
            VStack(alignment: .leading) {
                Text("New Matches")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(0..<5) { index in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.secondarySystemBackground))
                                .frame(width: 96, height: 120)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal, 8)
            .padding(.top)
        }
    }
}

#Preview {
    TinderEntry.Messages.NewMatches()
}
