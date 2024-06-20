//
//  ProfileHeader.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/18/24.
//

import SwiftUI

extension TinderEntry.Profile {
    struct Header: View {
        let user: User
        
        var body: some View {
            VStack {
                ZStack(alignment: .topTrailing) {
                    Image(user.profileImages[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .background {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 128, height: 128)
                                .shadow(radius: 10)
                        }
                    
                    Image(systemName: "pencil")
                        .imageScale(.small)
                        .foregroundStyle(.gray)
                        .background {
                            Circle()
                                .fill(.white)
                                .frame(width: 32, height: 32)
                        }
                        .offset(x: -8, y: 10)
                }
                
                Text("\(user.fullname), \(user.age)")
                    .font(.title2)
                    .fontWeight(.light)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 240)
        }
    }
}

#Preview {
    TinderEntry.Profile.Header(user: MockData.users[0])
}
