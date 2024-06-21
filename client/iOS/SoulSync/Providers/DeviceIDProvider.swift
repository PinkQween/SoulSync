//
//  DeviceIDProvider.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/20/24.
//

import Foundation

class DeviceIDProvider: ObservableObject {
    @Published var deviceID: String

    init(deviceID: String = "") {
        self.deviceID = deviceID
    }
}
