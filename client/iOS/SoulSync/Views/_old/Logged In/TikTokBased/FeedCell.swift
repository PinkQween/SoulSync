//
//  FeedCell.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/15/24.
//

import SwiftUI

extension TikTokEntry {
    struct FeedCell: View {
        let post: Int
        
        enum Heart {
            case like, dislike
        }
        
        @State var heartStatus: Heart? = .none
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(.pink)
                    .containerRelativeFrame([.horizontal, .vertical])
                    .overlay {
                        Text("Post \(post)")
                            .foregroundStyle(.white)
                    }
                
                VStack {
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            HStack {
                                Spacer()
                                
                                VStack(spacing: 15) {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "bell.fill")
                                            .foregroundStyle(.white)
                                            .font(.largeTitle)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "bookmark")
                                            .foregroundStyle(.white)
                                            .font(.largeTitle)
                                    }
                                    
                                    Button {
                                        heartStatus = heartStatus == .none ? .like : (
                                            heartStatus == .like ? .dislike : .none
                                        )
                                    } label: {
                                        Image(systemName: heartStatus != .none ? (
                                            heartStatus == .dislike ? "heart.slash" : "heart.fill"
                                        ) : "heart")
                                        .foregroundStyle(.white)
                                        .font(.largeTitle)
                                    }
                                    
                                    //                        Button {
                                    //
                                    //                        } label: {
                                    //                            Image(systemName: "heart.slash")
                                    //                                .foregroundStyle(.white)
                                    //                                .font(.largeTitle)
                                    //                        }
                                    
                                    Button {
                                        
                                    } label: {
                                        VStack {
                                            Image(systemName: "ellipsis.message")
                                                .foregroundStyle(.white)
                                                .font(.largeTitle)
                                            
                                            
                                            
                                            Text("4523")
                                                .font(.caption)
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "arrowshape.turn.up.right")
                                            .foregroundStyle(.white)
                                            .font(.largeTitle)
                                    }
                                }
                            }
                            
                            HStack {
                                Text("Hanna Skairipa • 15 years")
                                    .fontWeight(.semibold)
                                    .font(.title)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.625)
                                
                                //                            Spacer()
                            }
                            //                        .frame(width: UIScreen.main.bounds.width / 2 * 1.4)
                            
                            Text("Just a gril who likes animeJust a gril who likes animeJust a gril who likes animeJust a gril who likes animeJust a gril who likes anime")
                            //                            .frame(width: UIScreen.main.bounds.width / 2 * 1.2)
                        }
                        .foregroundStyle(.white)
                        .font(.subheadline)
                    }
                    .padding(.bottom, 80)
                }
                .padding()
            }
        }
    }
    
}

#Preview {
    //    FeedCell(post: 0)
    TikTokEntry()
        .colorScheme(.dark)
}
