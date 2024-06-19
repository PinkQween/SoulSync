//
//  Card.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/17/24.
//

struct CardModel {
    let user: User
}

extension CardModel: Identifiable, Hashable {
    var id: String { return user.id }
}
