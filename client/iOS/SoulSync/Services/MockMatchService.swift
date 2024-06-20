//
//  MockMatchServer.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/19/24.
//

struct MockMatchService: MatchServiceProtocol {
    func fetchMathces() async throws -> [Match] {
        return MockData.matches
    }
}
