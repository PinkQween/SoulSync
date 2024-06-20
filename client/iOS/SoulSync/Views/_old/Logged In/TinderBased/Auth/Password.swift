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
        @State private var password = ""
        
        var body: some View {
            NavigationStack {
                VStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your password?")
                            .fontWeight(.bold)
                            .font(.title)
                        
                        Text("Don't loose accses to your account, add your password")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        SecureField("Enter email", text: $password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                        
                        Divider()
                    }
                    .navigationBarBackButtonHidden()
                    .padding()
                    
                    Spacer()
                    
                    Button {
                        print("login")
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

#Preview {
    TinderEntry.Auth.Email()
}

