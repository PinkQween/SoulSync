//
//  EditProfile.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/18/24.
//

import SwiftUI

extension TinderEntry.Profile {
    struct EditProfile: View {
        @Environment(\.dismiss) var dismiss
        @State private var showCancelationAlert = false
        @State private var bio = ""
        @State private var occupation = ""
        
        let user: User
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    ProfileImageGrid(user: user)
                        .padding()
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading) {
                            Text("ABOUT ME")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding(.leading)
                            
                            TextField("Add you bio", text: $bio, axis: .vertical)
                                .padding()
                                .frame(height: 96, alignment: .top)
                                .background(Color(.secondarySystemBackground))
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("OCCUPATION")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding(.leading)
                            
                            HStack {
                                Image(systemName: "person.text.rectangle")
                                Text("occupation")
                                
                                Spacer()
                                
                                Text(occupation)
                                    .font(.footnote)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("GENDER")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding(.leading)
                            
                            HStack {
                                Text("Female")
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .imageScale(.small)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("SEXUAL ORIENTATION")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding(.leading)
                            
                            HStack {
                                Text("Straight")
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .imageScale(.small)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .font(.subheadline)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .navigationTitle("Edit Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            showCancelationAlert.toggle()
                        }
                        .foregroundStyle(.red).alert(isPresented: $showCancelationAlert) {
                            Alert(title: Text("Confirmation"), message: Text("Are you sure you want to cancel?"), primaryButton: .default(Text("Continue editing"), action: {
                                // Handle cancel action if needed
                            }), secondaryButton: .destructive(Text("Confirm"), action: {
                                dismiss()
                            }))
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            // TODO: Save profile
                            
                            dismiss()
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.accent)
                    }
                }
            }
        }
    }
}

#Preview {
    TinderEntry.Profile.EditProfile(user: MockData.users[2])
}
