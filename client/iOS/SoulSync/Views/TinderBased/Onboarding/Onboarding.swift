//
//  Welcome.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/21/24.
//

import SwiftUI

extension TinderEntry {
    struct Onboarding: View {
        let rules = OnboardingConstants.rules
        
        var body: some View {
            NavigationStack {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(.tinderLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 64)
                        
                        Text("Welcome to Tinder.")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Please follow these house rules.")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(Array(rules.keys), id: \.self) { key in
                        Rule(title: key, description: rules[key]!)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    TinderEntry.Onboarding()
}

extension TinderEntry.Onboarding {
    struct Rule: View {
        let title: String
        let description: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .foregroundStyle(.gray)
            }
            .font(.subheadline)
        }
    }
}
