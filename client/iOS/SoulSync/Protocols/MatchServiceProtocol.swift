//
//  MatchServiceProtocol.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/19/24.
//

protocol MatchServiceProtocol {
    func fetchMathces() async throws -> [Match]
}
