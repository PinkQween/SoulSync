//
//  Auth.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/19/24.
//

import SwiftUI

extension TinderEntry {
    struct Auth: View {
        @State private var showAuthFlow = false
        
        var body: some View {
            NavigationStack {
                VStack {
                    Image(.tinderLogoWhite)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 40)
                    
                    VStack(spacing: 8) {
                        Text("It Starts ").bold() +
                        Text("with")
                        
                        Text("a ") +
                        Text("Swipe").bold()
                    }
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("By tapping 'Sign in' you agree to our Terms. Learn how we  proccesws your data in our Privacy Policy and Cookies Policy")
                            .multilineTextAlignment(.center)
                            .font(.footnote)
                            .foregroundStyle(.white)
                        
                        Button {
                            showAuthFlow.toggle()
                        } label: {
                            Text("Create Account")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .frame(width: 340, height: 50)
                                .background(.white)
                                .clipShape(Capsule())
                        }
                        
                        Button {
                            showAuthFlow.toggle()
                        } label: {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 340, height: 50)
                        }
                        .overlay {
                            Capsule()
                                .stroke(.white, lineWidth: 1.5)
                        }
                        
                        NavigationLink {
                            Text("Forgot password?")
                        } label: {
                            Text("Trouble signing in?")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .fullScreenCover(isPresented: $showAuthFlow, content: {
                    Email()
                })
                .frame(maxWidth: .infinity)
                .background(gradientBackground)
            }
        }
    }
}

private extension TinderEntry.Auth {
    var gradientBackground: LinearGradient {
        LinearGradient(
            colors: [
                .tertiaryPink,
                .primaryPink,
                .secondaryPink
            ],
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
    }
}

#Preview {
    TinderEntry.Auth()
}
