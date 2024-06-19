//
//  CardStack.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI

extension TinderEntry.Home {
    struct CardStack: View {
        @EnvironmentObject var matchManager: MatchManager
        @State private var showMatchView = false
        @StateObject var viewModel = CardsViewModel(service: CardService())
        
        var body: some View {
            NavigationStack {
                ZStack {
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
                    .blur(radius: showMatchView ? 20 : 0)
                    
                    if showMatchView {
                        Match(show: $showMatchView)
                    }
                }
                .animation(.easeInOut, value: showMatchView)
                .onReceive(matchManager.$matchedUser) { user in
                    showMatchView = user != nil
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        if !showMatchView {
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
}

#Preview {
    ZStack {
        TinderEntry.Home.CardStack()
    }
    .environmentObject(MatchManager())
}
