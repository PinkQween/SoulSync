//
//  MatchManager.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/18/24.
//

import Foundation

@MainActor
class MatchManager: ObservableObject {
    @Published var matchedUser: User?
    @Published var matches = [Match]()
    
    private let service: MatchServiceProtocol
    
    init(service: MatchServiceProtocol) {
        self.service = service
    }
    
    func fetchMatches() async {
        do {
            self.matches = try await service.fetchMathces()
        } catch {
            dump(error)
        }
    }
    
    func checkForMatch(withUser user: User) {
        let didMatch = Bool.random()
        
        if didMatch {
            matchedUser = user
        }
    }
}
