//
//  SignUpModals.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 12/17/23.
//

import Foundation

// MARK: - Preferences
struct Preferences {
    // MARK: - Standered Options
    struct StanderedOption: Codable {
        let options: [String]
        let multiple: Bool
    }
    
    // MARK: - Interests Options
    struct InterestsOptions: Codable {
        let options: [Option]
        let multiple: Bool
    }
    
    // MARK: - Intrest Option
    struct Option: Codable, Hashable {
        let option: String
        let subIntrests: [Option]?
        
        // Implementing Hashable conformance
        func hash(into hasher: inout Hasher) {
            hasher.combine(option)
        }
        
        static func ==(lhs: Option, rhs: Option) -> Bool {
            return lhs.option == rhs.option
        }
    }
    
    struct PreferencesModel: Codable {
        let genderOptions: String
        let sexOptions: String
        let interestsOptions: [String]
        let sexualityOptions: String
        let relationshipStatusOptions: String
        let ageRange: String
    }
    
    struct PreferencesOptionsModel: Codable {
        let genderOptions, sexOptions, sexualityOptions, relationshipStatusOptions, ageRange: StanderedOption
        let interestsOptions: InterestsOptions
        
        static func loadPreferences(completion: @escaping (PreferencesOptionsModel?) -> Void) {
            if let url = Bundle.main.url(forResource: "preferences", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decodedPreferences = try JSONDecoder().decode(PreferencesOptionsModel.self, from: data)
                    completion(decodedPreferences)
                } catch {
                    print("Error decoding preferences JSON: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
}
