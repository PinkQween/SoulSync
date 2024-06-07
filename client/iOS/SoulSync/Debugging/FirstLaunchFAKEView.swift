//
//  FirstLaunchFAKEView.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/5/24.
//

import SwiftUI

struct FirstLaunchFAKEView: View {
    @State private var selectedTab = 0
    @State private var isSignUp = true
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                WelcomeView(selectedTab: $selectedTab, isSignUp: $isSignUp)
                    .tag(0)
                    .transition(.slide)
                OnboardingProcess(signUp: $isSignUp)                    .tag(1)
                    .transition(.slide)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .foregroundColor(Color.white)
        .onAppear(perform: {
            print(UserDefaults.standard.string(forKey: "token") ?? "Not found")
        })
    }
}

struct WelcomeView: View {
    @Binding var selectedTab: Int
    @Binding var isSignUp: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            Text("Welcome to\nSoulSync")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                isSignUp = false
                
                withAnimation {
                    selectedTab = 1
                }
            }, label: {
                Text("Login")
                    .font(.headline)
                    .frame(width: 300.0, height: 60.0)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(23)
            })
            
            Button(action: {
                isSignUp = true
                
                withAnimation {
                    selectedTab = 1
                }
            }, label: {
                Text("Sign Up")
                    .font(.headline)
                    .frame(width: 300.0, height: 60.0)
                    .cornerRadius(23)
                    .overlay(
                        RoundedRectangle(cornerRadius: 23)
                            .stroke(Color.white, lineWidth: 2)
                            .padding(2)
                    )
            })
            
            Spacer()
            Spacer()
            Spacer()
        }
    }
}

struct OnboardingProcess: View {
    @State private var isSignUpSuccessful = false
    @State private var isLoginSuccessful = false
    @Binding var signUp: Bool
    @State private var isCompleteSignUp = false
//    @State private var phone = ""
    @State private var email = ""
    @State private var token = ""
    @State private var addedDetails = false
    @State private var addedPreferences = false
    @State private var addedPitch = false
    
    var body: some View {
        Group {
            if signUp {
                signUpView
            } else {
                loginView
            }
        }
        .transition(.slide)
    }
    
    @ViewBuilder
    private var loginView: some View {
        if isLoginSuccessful {
            RewelcomeView()
        } else {
            LoginInfoView(isLoginSuccessful: $isLoginSuccessful)
        }
    }
    
    @ViewBuilder
    private var signUpView: some View {
        if !isSignUpSuccessful {
            SignUpInfoView(isSignUpSuccessful: $isSignUpSuccessful, email: $email, token: $token)
        } else if !isCompleteSignUp {
            PhoneVerificationView(isCompleteSignUp: $isCompleteSignUp, email: $email, token: $token)
        } else if !addedDetails {
            DescriptorsView(addedDetails: $addedDetails, email: $email)
        } else if !addedPreferences {
            PreferencesView(addedPreferences: $addedPreferences, email: $email)
        } else if !addedPitch {
            PitchCreatorView(addedPitch: $addedPitch)
        } else {
            RewelcomeView()
        }
    }
}

#Preview {
    OnBoardingFAKE()
}
