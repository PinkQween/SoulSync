//
//  AuthServiceProtocol.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/19/24.
//

protocol AuthServiceProtocol {
    func createUser(with authDataStore: AuthDataStore) async throws -> String
    func login(with authDataStore: AuthDataStore) async throws -> String
    func signOut()
}
