//
//  MockAuthService.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/19/24.
//

import Foundation

struct MockAuthService: AuthServiceProtocol {
    func createUser(with authDataStore: AuthDataStore) async throws -> String {
        return NSUUID().uuidString
    }
    
    func login(with authDataStore: AuthDataStore) async throws -> String {
        return NSUUID().uuidString
    }
    
    func signOut() {
        
    }
}
