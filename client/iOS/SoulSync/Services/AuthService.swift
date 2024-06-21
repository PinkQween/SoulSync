
//
//  AuthService.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/19/24.
//

import FirebaseAuth

struct AuthService: AuthServiceProtocol {
    func createUser(with authDataStore: AuthDataStore) async throws -> String {
        let results = try await Auth.auth().createUser(withEmail: authDataStore.email, password: authDataStore.password)
        return results.user.uid
    }
    
    func login(with authDataStore: AuthDataStore) async throws -> String {
        let results = try await Auth.auth().signIn(withEmail: authDataStore.email, password: authDataStore.password)
        return results.user.uid
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}
