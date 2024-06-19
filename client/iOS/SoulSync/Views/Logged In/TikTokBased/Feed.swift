//
//  Feed.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/15/24.
//

import SwiftUI

extension TikTokEntry {
    struct Feed: View {
        var body: some View {
            ZStack {
                Color.pink
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<10) { post in
                            FeedCell(post: post)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    TikTokEntry.Feed()
}
