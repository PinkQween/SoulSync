//
//  UITemplateDecider.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import SwiftUI

struct UITemplateDecider: View {
    enum Templates {
        case tinder, tiktok
    }
    
    @State var template: Templates = .tinder
    
    var body: some View {
        if (template == .tinder) {
            TinderEntry()
        } else {
            TikTokEntry()
        }
    }
}

#Preview {
    UITemplateDecider()
}
