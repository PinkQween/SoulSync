//
//  CardUserInfo.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI

extension TinderEntry.Home.CardStack.Card {
    struct CardUserInfo: View {
        let user: User
        @Binding var showProfileModel: Bool
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text(user.fullname)
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    Text("\(user.age)")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        showProfileModel.toggle()
                    } label: {
                        Image(systemName: "arrow.up.circle")
                            .fontWeight(.bold)
                            .imageScale(.large)
                    }
                }
                
                Text("Some test bio")
                    .font(.subheadline)
                    .lineLimit(2)
            }
            .foregroundStyle(.white)
            .padding()
            .padding(.horizontal)
            .background(
                LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
            )
        }
    }
}

#Preview {
    TinderEntry.Home.CardStack.Card.CardUserInfo(user: .init(
        id: NSUUID().uuidString,
        fullname: "Megan Fox",
        age: 38,
        profileImages: [
            "megan-fox-1",
            "megan-fox-2",
        ]
    ), showProfileModel: .constant(false))
}
