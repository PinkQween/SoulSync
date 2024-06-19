//
//  MockData.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

import Foundation

struct MockData {
    static let users: [User] = [
        .init(
            id: NSUUID().uuidString,
            fullname: "Megan Fox",
            age: 38,
            profileImages: [
                "megan-fox-1",
                "megan-fox-2",
            ]
        ),
        .init(
            id: NSUUID().uuidString,
            fullname: "Mistuha",
            age: 17,
            profileImages: [
                "mitsuha-1",
                "mitsuha-2",
                "mitsuha-3",
                "mitsuha-4",
            ]
        ),
        .init(
            id: NSUUID().uuidString,
            fullname: "Hina",
            age: 15,
            profileImages: [
                "hina-1",
                "hina-2",
                "hina-3",
                "hina-4",
                "hina-5",
            ]
        ),
        .init(
            id: NSUUID().uuidString,
            fullname: "Taki",
            age: 17,
            profileImages: [
                "taki-1",
                "taki-2",
                "taki-3",
            ]
        ),
        .init(
            id: NSUUID().uuidString,
            fullname: "Hodaka",
            age: 16,
            profileImages: [
                "hodaka-1",
            ]
        ),
    ]
}
