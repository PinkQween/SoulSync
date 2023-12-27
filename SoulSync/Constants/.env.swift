//
//  .env.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 12/26/23.
//

import Foundation

struct Env {
    private static func notFound() -> Never {
        fatalError("Environment variable not found")
    }
    
    public static let ssEndpointURI: String = {
        guard let value = ProcessInfo.processInfo.environment["SS_URI"] else {
            notFound()
        }
        
        print(value)
        return value
    }()
}
