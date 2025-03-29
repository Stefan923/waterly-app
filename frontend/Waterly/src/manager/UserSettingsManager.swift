//
//  UserSettingsManager.swift
//  Waterly
//
//  Created by Stefan Popescu on 12.06.2023.
//

import Foundation

class UserSettingsManager {
    static let shared = UserSettingsManager()
    private var userSettings: UserSettings?

    private init() {}

    func setUserSettings(_ userSettings: UserSettings) {
        self.userSettings = userSettings
    }

    func getUserSettings() -> UserSettings? {
        return userSettings
    }
}
