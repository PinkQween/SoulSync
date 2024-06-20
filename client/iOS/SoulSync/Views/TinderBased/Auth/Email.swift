//
//  Email.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/19/24.
//

import SwiftUI

extension TinderEntry.Auth {
    struct Email: View {
        @Environment(\.dismiss) var dismiss
        @EnvironmentObject var authManager: AuthManager
        @EnvironmentObject var authDataStore: AuthDataStore
        
        var body: some View {
            NavigationStack {
                VStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your email?")
                            .fontWeight(.bold)
                            .font(.title)
                        
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        TextField("Enter email", text: $authDataStore.email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                        
                        Divider()
                    }
                    .padding()
                    
                    Spacer()
                    
                    NavigationLink {
                        Password()
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

private extension TinderEntry.Auth.Email {
    var subtitle: String {
        guard let authType = authManager.authType else {
            return "Don't loose accses to your account, add your email"
        }
        
        switch authType {
            case .createAccount:
                return "Don't loose accses to your account, add your email"
            case .login:
                return "Enter the email associated with your account to log back in"
        }
    }
}

#Preview {
    TinderEntry.Auth.Email()
        .environmentObject(AuthManager(service: MockAuthService()))
        .environmentObject(AuthDataStore())
}
