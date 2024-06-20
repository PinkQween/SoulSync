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
        @State private var email = ""
        
        var body: some View {
            NavigationStack {
                VStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your email?")
                            .fontWeight(.bold)
                            .font(.title)
                        
                        Text("Don't loose accses to your account, add your email")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        TextField("Enter email", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                        
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

#Preview {
    TinderEntry.Auth.Email()
}
