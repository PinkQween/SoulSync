//
//  AuthManager.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/19/24.
//

import FirebaseAuth
import SwiftUICore

@MainActor
class AuthManager: ObservableObject {
    @Published var authType: AuthType?
    @Published var authState: AuthState = .unauthenticated
    
    private let service: AuthServiceProtocol
    
    init(service: AuthServiceProtocol) {
        self.service = service
        
        if let currentUid = Auth.auth().currentUser?.uid {
            self.authState = .authenticated(currentUid)
        }
    }
    
    func authenticate(with authDataStore: AuthDataStore) async {
        guard let authType else { return }
        
        do {
            switch authType {
            case .createAccount:
                self.authState = .authenticated(try await service.createUser(with: authDataStore))
            case .login:
                self.authState = .authenticated(try await service.login(with: authDataStore))
            }
        } catch {
            dump(error)
        }
        
        self.authType = nil
    }
    
    func signOut() {
        withAnimation {
            authState = .unauthenticated
        }
        
        service.signOut()
    }
}
