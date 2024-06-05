//
//  KeychainManager.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/4/24.
//

import Security
import Foundation

class KeychainManager {
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    class func loadData(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
    
    class func delete(key: String) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ] as [String : Any]
        
        return SecItemDelete(query as CFDictionary)
    }
    
    class func save(key: String, value: String) -> OSStatus {
        if let data = value.data(using: .utf8) {
            return save(key: key, data: data)
        }
        return errSecParam
    }
    
    class func loadString(key: String) -> String {
        if let data = loadData(key: key) {
            return String(data: data, encoding: .utf8) ?? ""
        }
        return ""
    }
}
