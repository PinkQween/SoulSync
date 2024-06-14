//
//  Rewelcome.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/2/24.
//

import SwiftUI

struct RewelcomeView: View {
    @State var ready: Bool = false
    
    var body: some View {
        if (!ready) {
            VStack {
                Spacer()
                Spacer()
                
                Text("Welcome!")
                    .font(.largeTitle)
                
                Spacer()
                
                Button {
                    withAnimation {
                        ready.toggle()
                    }
                } label: {
                    Text("Continue")
                        .font(.title3)
                }
                .bold()
                .buttonStyle(.borderedProminent)
                
                Spacer()
                Spacer()
            }
        } else {
            Color.white
        }
    }
}

#Preview {
    RewelcomeView()
        .preferredColorScheme(.dark)
}
