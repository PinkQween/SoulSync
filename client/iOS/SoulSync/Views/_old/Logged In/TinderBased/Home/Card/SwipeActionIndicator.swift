//
//  SwipeActionIndicator.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI

extension TinderEntry.Home.CardStack.Card {
    struct SwipeActionIndicator: View {
        @Binding var xOffset: CGFloat
        
        var body: some View {
            HStack {
                Text("LIKE")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundStyle(.green)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.green, lineWidth: 2)
                            .frame(width: 100, height: 48)
                    }
                    .rotationEffect(.degrees(-45))
                    .opacity(Double(xOffset / SizeConstants.screenCutOff))
                
                Spacer()
                
                
                    Text("NOPE")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(.red)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.red, lineWidth: 2)
                                .frame(width: 100, height: 48)
                        }
                        .rotationEffect(.degrees(45))
                        .opacity(Double(xOffset / SizeConstants.screenCutOff) * -1)
            }
            .padding(40)
        }
    }
}

#Preview {
    TinderEntry.Home.CardStack.Card.SwipeActionIndicator(xOffset: .constant(200))
}

#Preview {
    TinderEntry.Home.CardStack.Card.SwipeActionIndicator(xOffset: .constant(-200))
}
