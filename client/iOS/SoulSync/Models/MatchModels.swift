//
//  Match.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/19/24.
//

import Foundation

struct Match: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let timestamp: Date
    
    var user: User?
}
