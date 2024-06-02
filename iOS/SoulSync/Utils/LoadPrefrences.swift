//
//  LoadPrefrences.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 12/17/23.
//

import Foundation

class PreferencesLoader {
    static func loadPreferences(completion: @escaping (Preferences.PreferencesOptionsModel?) -> Void) {
        if let url = Bundle.main.url(forResource: "preferences", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedPreferences = try? JSONDecoder().decode(Preferences.PreferencesOptionsModel.self, from: data) {
            completion(decodedPreferences)
        } else {
            completion(nil)
        }
    }
}
