//
//  CardService.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

struct CardService {
    func fetchCardModels() async throws -> [CardModel] {
        let users = MockData.users
        
        return users.map({
            CardModel(user: $0)
        }).reversed()
    }
}
