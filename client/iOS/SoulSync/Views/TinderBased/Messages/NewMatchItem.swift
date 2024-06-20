//
//  NewMatchItem.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/19/24.
//

import SwiftUI

extension TinderEntry.Messages.NewMatches {
    struct NewMatchItem: View {
        let match: Match
        
        var body: some View {
            VStack {
                if let user = match.user {
                    Image(user.profileImages[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(user.firstName)
                        .foregroundStyle(.primary)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    TinderEntry.Messages.NewMatches.NewMatchItem(match: MockData.matches[0])
}
