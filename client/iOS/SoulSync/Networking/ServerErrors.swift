//
//  ServerErrors.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/4/24.
//

enum ServerErrors: String {
    case WRONG_CODE = "WRONG_CODE"
    case PASSWORD_MISMATCH = "PASSWORD_MISMATCH"
    case USER_NOT_FOUND = "USER_NOT_FOUND"
    case WRONG_PASSWORD = "WRONG_PASSWORD"
    case EMAIL_EXISTS = "EMAIL_EXISTS"
    case NO_TOKEN = "NO_TOKEN"
    case INVALID_TOKEN = "INVALID_TOKEN"
}
