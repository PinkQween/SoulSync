//
//  User.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

struct User: Identifiable, Hashable {
    let id: String
    let fullname: String
    var age: Int
    var profileImages: [String]
}
