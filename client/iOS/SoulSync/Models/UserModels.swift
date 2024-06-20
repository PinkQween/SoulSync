//
//  User.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

struct User: Identifiable, Hashable, Codable {
    let id: String
    let fullname: String
    var age: Int
    var profileImages: [String]
}

extension User {
    var firstName: String {
        return fullname.components(separatedBy: " ")[0]
    }
}
