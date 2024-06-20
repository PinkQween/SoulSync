//
//  Wallet.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/12/24.
//

import SwiftUI
import PassKit

struct TEST_Wallet: View {
    @State private var newPass: PKPass?
    @State private var passSheetVisible: Bool = false
    
    var body: some View {
        AddPassToWalletButton {
            
        }
        .sheet(isPresented: self.$passSheetVisible) {
            
        }
    }
}

#Preview {
    TEST_Wallet()
}
