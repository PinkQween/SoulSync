//
//  AuthModels.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/20/24.
//

enum AuthType: Int, Identifiable {
    case createAccount, login
    
    var id: Int { return self.rawValue }
}

enum AuthState {
    case unauthenticated, authenticated(String)
}
