//
//  File.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/14/24.
//

import Foundation

class ReloadViewHelper: ObservableObject {
    func reloadView() {
        objectWillChange.send()
    }
}
