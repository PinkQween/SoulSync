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
    @Published var deviceIDProvider: DeviceIDProvider
    
    init(email: String = "", password: String = "", deviceIDProvider: DeviceIDProvider) {
        self.email = email
        self.password = password
        self.deviceIDProvider = deviceIDProvider
    }
}
