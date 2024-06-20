//
//  AuthDataStore.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/20/24.
//

import Foundation

class AuthDataStore: ObservableObject {
    @Published var email = ""
    @Published var password = ""
}
