//
//  ProfileImageGrid.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/18/24.
//

import SwiftUI

extension TinderEntry.Profile.EditProfile {
    struct ProfileImageGrid: View {
        let user: User
        
        var body: some View {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<6) { index in
                    if index < user.profileImages.count {
                        Image(user.profileImages[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        ZStack(alignment: .bottomTrailing) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.secondarySystemBackground))
                                .frame(width: 110, height: 160)
                            
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                                .foregroundStyle(Color(.primaryPink))
                                .offset(x: 4, y: 4)
                        }
                    }
                }
            }
        }
    }
}

private extension TinderEntry.Profile.EditProfile.ProfileImageGrid {
    private var columns: [GridItem] {
        return [
            .init(.flexible()),
            .init(.flexible()),
            .init(.flexible()),
        ]
    }
    
    var imageWidth: CGFloat {
        return 110
    }
    var imageHeight: CGFloat {
        return 160
    }
}

#Preview {
    TinderEntry.Profile.EditProfile.ProfileImageGrid(user: MockData.users[2])
}
