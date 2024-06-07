//
//  FirstLaunchFAKEView.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/5/24.
//

import SwiftUI

struct FirstLaunchFAKEView: View {
    @State var selectedTab: Int
    @State private var isSignUp = true
    
    @State var isSignUpSuccessful: Bool
    @State var isLoginSuccessful: Bool
    @State var isCompleteSignUp: Bool
    @State var email: String
    @State var token: String
    @State var addedDetails: Bool
    @State var addedPreferences: Bool
    @State var addedPitch: Bool
    @State var addedBio: Bool
    @State var isSwipeable: Bool
    @State var pitchURL: URL?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if isSwipeable {
                TabView(selection: $selectedTab) {
                    WelcomeFAKEView(selectedTab: $selectedTab, isSignUp: $isSignUp)
                        .tag(0)
                        .transition(.slide)
                    
                    FAKEOnboardingProcess(signUp: $isSignUp, swipeable: $isSwipeable, isSignUpSuccessful: isSignUpSuccessful, isLoginSuccessful: isLoginSuccessful, isCompleteSignUp: isCompleteSignUp, email: email, token: token)
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

struct WelcomeFAKEView: View {
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

struct FAKEOnboardingProcess: View {
    @Binding var signUp: Bool
    @Binding var swipeable: Bool
    
    @State var isSignUpSuccessful: Bool
    @State var isLoginSuccessful: Bool
    @State var isCompleteSignUp: Bool
    @State var email: String
    @State var token: String
    
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

#Preview {
    FirstLaunchFAKEView(selectedTab: 1, isSignUpSuccessful: true, isLoginSuccessful: false, isCompleteSignUp: true, email: "hanna@hannaskairipa.com", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuZXdVc2VyIjp7InVzZXJuYW1lIjoiSGFubmEgU2thaXJpcGEiLCJiaXJ0aGRhdGUiOiIxMi8xMC8wOCIsImVtYWlsIjoiaGFubmFAaGFubmFza2FpcmlwYS5jb20iLCJoYXNoZWRQYXNzd29yZCI6IiQyYiQxMCR0aGhNRk12Tkg2RWk5eGpxLzk1NTAuc2F3Zk55d3lyUERYZDZneFpWdkNaMEx0V0dDaXVDSyIsImNvZGUiOjIxNTc4OCwiZGV2aWNlSUQiOlsiMmE3OGM0ZmRlZTY1YmQ1NzBjNjYxY2U1Y2ZlNGQ2MzFhOGY3YjQwOWE2NzgyYmMzNzM1MjFhN2FjYTljZTBiZSJdLCJ2ZXJpZmllZCI6ZmFsc2UsInRlbXAiOnRydWUsImNyZWF0ZWRBdCI6MTcxNzY5MDQ3Mjk1MX0sImlhdCI6MTcxNzY5MDQ3Mn0.sSTvCjFo8VA26GXLhYrf4UDymwTOT84lgyfaNTRMkeY", addedDetails: true, addedPreferences: true, addedPitch: true, addedBio: false, isSwipeable: true, pitchURL: Bundle.main.url(forResource: "video1", withExtension: "mp4"))
        .preferredColorScheme(.dark)
}
