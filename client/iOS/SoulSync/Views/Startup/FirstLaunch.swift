//
//  FirstLaunch.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 11/27/23.
//

import SwiftUI

struct FirstLaunchView: View {
    @State private var selectedTab = 0
    @State private var isSignUp = true
    @State private var isSwipeable = true
    @State private var addedDetails = false
    @State private var addedPreferences = false
    @State private var addedPitch = false
    @State private var email = ""
    @State private var pitchURL: URL?
    @State private var addedBio = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if isSwipeable {
                TabView(selection: $selectedTab) {
                    WelcomeFAKEView(selectedTab: $selectedTab, isSignUp: $isSignUp)
                        .tag(0)
                        .transition(.slide)
                    
                    OnboardingProcess(signUp: $isSignUp, swipeable: $isSwipeable, email: $email)
                        .tag(1)
                        .transition(.slide)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            } else {
                if isSignUp {
                    signUpView
                } else {
                    loginView
                }
            }
        }
        .foregroundColor(Color.white)
        .onAppear(perform: {
            print(UserDefaults.standard.string(forKey: "token") ?? "Not found")
        })
    }
    
    @ViewBuilder
    private var signUpView: some View {
        if !addedDetails {
            DescriptorsView(addedDetails: $addedDetails, email: $email)
        } else if !addedPreferences {
            PreferencesView(addedPreferences: $addedPreferences, email: $email)
        } else if !addedPitch {
            PitchCreatorView(addedPitch: $addedPitch, pitchURL: $pitchURL)
        } else if !addedBio {
            MatchingBio(manager: PreviewVideoPlayerManager(url: pitchURL!), addedBio: $addedBio, addedPitch: $addedPitch, video: pitchURL!)
        } else {
            RewelcomeView()
        }
    }
    
    @ViewBuilder
    private var loginView: some View {
        RewelcomeView()
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
    @Binding var signUp: Bool
    @Binding var swipeable: Bool
    @Binding var email: String
    
    @State var isSignUpSuccessful = false
    @State var isLoginSuccessful = false
    @State var isCompleteSignUp = false
    @State var token = ""
    
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
            Color.clear
                    .onAppear(perform: {
                        swipeable.toggle()
                    })
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
        } else {
            Color.clear
                .onAppear(perform: {
                    swipeable.toggle()
                })
        }
    }
}



struct FirstLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchView()
            .preferredColorScheme(.dark)
    }
}
