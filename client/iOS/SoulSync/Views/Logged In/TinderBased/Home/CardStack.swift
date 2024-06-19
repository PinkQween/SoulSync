//
//  CardStack.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI

extension TinderEntry.Home {
    struct CardStack: View {
        @ObservedObject var viewModel = CardsViewModel(service: CardService())
        
        var body: some View {
            NavigationStack {
                ZStack {
                    VStack {
                        Text("That's all\nwe have for now!")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.gray.opacity(0.6))
                            .fontWeight(.heavy)
                        
                        // TODO: Invite friends to help app grow
                    }
                    
                    ForEach(viewModel.cardModels) { card in
                        VStack(spacing: 16) {
                            Card(viewModel: viewModel, model: card)
                            
                            SwipeActionButtons(viewModel: viewModel)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Image("Tinder-logo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 88)
                    }
                }
            }
        }
    }
}

#Preview {
    TinderEntry.Home.CardStack()
}
