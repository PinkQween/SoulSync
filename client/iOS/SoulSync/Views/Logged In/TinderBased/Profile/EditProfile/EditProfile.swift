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
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    
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
    TinderEntry.Profile.EditProfile()
}
