//
//  Password.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/19/24.
//

import SwiftUI

extension TinderEntry.Auth {
    struct Password: View {
        @Environment(\.dismiss) var dismiss
        @EnvironmentObject var authManager: AuthManager
        @EnvironmentObject var authDataStore: AuthDataStore
        
        var body: some View {
            NavigationStack {
                VStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your password?")
                            .fontWeight(.bold)
                            .font(.title)
                        
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        SecureField("Enter password", text: $authDataStore.password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(
                                authManager.authType == .createAccount ? .newPassword : .password
                            )
                        
                        Divider()
                    }
                    .navigationBarBackButtonHidden()
                    .padding()
                    
                    Spacer()
                    
                    Button {
                        onNextTapped()
                    } label: {
                        Text("Next")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .frame(width: 340, height: 50)
                            .background(.primaryPink)
                            .clipShape(Capsule())
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .fontWeight(.heavy)
                                .foregroundStyle(.primaryText)
                        }
                    }
                }
            }
        }
    }
}

private extension TinderEntry.Auth.Password {
    var subtitle: String {
        guard let authType = authManager.authType else {
            return "Don't loose accses to your account, add your password"
        }
        
        switch authType {
            case .createAccount:
                return "Don't loose accses to your account, add your password"
            case .login:
                return "Enter the password associated with your account to log back in"
        }
    }
    
    func onNextTapped() {
        Task {
            await authManager.authenticate(with: authDataStore)
        }
    }
}

#Preview {
    TinderEntry.Auth.Password()
        .environmentObject(AuthManager(service: MockAuthService()))
        .environmentObject(AuthDataStore())
}

