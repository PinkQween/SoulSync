//
//  JailbreakDetector.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/1/24.
//

import UIKit

class JailbreakDetection {
    static func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        let paths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt"
        ]
        
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        if let bash = fopen("/bin/bash", "r") {
            fclose(bash)
            return true
        }
        
        let testPath = "/private/" + UUID().uuidString
        do {
            try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            return false
        }
        #endif
    }
}
