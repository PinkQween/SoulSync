//
//  UserProfileView.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/18/24.
//

import SwiftUI

extension TinderEntry.Home.CardStack.Card {
    struct UserProfileView: View {
        @Environment(\.dismiss) var dismiss
        @State private var currentImageIndex = 0
        let user: User
        
        var body: some View {
            VStack {
                HStack {
                    Text(user.fullname)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("\(user.age)")
                        .font(.title2)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.down.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundStyle(.primaryPink)
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack {
                        ZStack(alignment: .top) {
                            Image(user.profileImages[currentImageIndex])
                                .resizable()
                                .scaledToFill()
                                .overlay {
                                    ImageScrollingOverlay(currentImageIndex: $currentImageIndex, imageCount: user.profileImages.count)
                                }
                                .background(.primary)
                                .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                            
                            CardImageIndicator(currentImageIndex: currentImageIndex, imageCount: user.profileImages.count)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About me")
                                .fontWeight(.semibold)
                            
                            //                            if let bio = user.bio {
                            Text("some test bio")
                            //                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray5))
                        .font(.subheadline)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Essentials")
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "person")
                            
                            Text("Female")
                            
                            Spacer()
                        }
                        
                        HStack {
                            Image(systemName: "arrow.down.forward.and.arrow.up.backward.circle")
                            
                            Text("Straight")
                            
                            Spacer()
                        }
                        
                        HStack {
                            Image(systemName: "graduationcap")
                            
                            Text("CSU")
                            
                            Spacer()
                        }
                        
                        HStack {
                            Image(systemName: "person.text.rectangle")
                            
                            Text("Actress")
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .font(.subheadline)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}


#Preview {
    TinderEntry.Home.CardStack.Card.UserProfileView(user: MockData.users[2])
}
