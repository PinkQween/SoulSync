//
//  UserMatch.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/18/24.
//

import SwiftUI

extension TinderEntry.Home {
    struct Match: View {
        @Binding var show: Bool
        @EnvironmentObject var matchManager: MatchManager
        
        var body: some View {
            ZStack {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 120) {
                        VStack {
                            Image(.itsamatch)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250)
                            
                            if let matchedUser = matchManager.matchedUser {
                                Text("You and \(matchedUser.fullname) have liked each other.")
                                    .foregroundStyle(.white)
                            } else {
                                Text("You and \("Kelly") have liked each other.")
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        HStack(spacing: 16) {
                            Image(MockData.users[0].profileImages[0])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(.white, lineWidth: 2)
                                        .shadow(radius: 4)
                                }
                            
                            if let matchedUser = matchManager.matchedUser {
                                Image(matchedUser.profileImages[0])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(.white, lineWidth: 2)
                                            .shadow(radius: 4)
                                    }
                            } else {
                                Image(MockData.users[2].profileImages[0])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(.white, lineWidth: 2)
                                            .shadow(radius: 4)
                                    }
                            }
                        }
                        
                        VStack(spacing: 16) {
                            Button("Send a Message") {
                                show.toggle()
                            }
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 350, height: 44)
                            .background(.primaryPink)
                            .clipShape(Capsule())
                            
                            Button("Keep Swiping") {
                                show.toggle()
                            }
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 350, height: 44)
                            .background(.clear)
                            .clipShape(Capsule())
                            .overlay {
                                Capsule()
                                    .stroke(.white, lineWidth: 1)
                                    .shadow(radius: 4)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        TinderEntry.Home.Match(show: .constant(true))
    }
    .environmentObject(MatchManager(service: MockMatchService()))
}
