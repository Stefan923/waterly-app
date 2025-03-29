//
//  UserSettings.swift
//  Waterly
//
//  Created by Stefan Popescu on 02.06.2023.
//

import Foundation

class UserSettings: ObservableObject, Codable {
    var defaultLiquidsConsumption: Int
    var defaultCaloriesConsumption: Int
    var dailyLiquidsConsumptionTarget: Int
    var dailyCaloriesConsumptionTarget: Int
    var dailyLiquidsConsumptions: Int
    var dailyCaloriesConsumptions: Int
    var gesturesDetection: Bool
    var developerMode: Bool
    var scheduleSettings: ScheduleSettings

    enum CodingKeys: String, CodingKey {
        case defaultLiquidsConsumption
        case defaultCaloriesConsumption
        case dailyLiquidsConsumptionTarget
        case dailyCaloriesConsumptionTarget
        case dailyLiquidsConsumptions
        case dailyCaloriesConsumptions
        case gesturesDetection
        case developerMode
        case scheduleSettings
    }

    init(defaultLiquidsConsumption: Int, defaultCaloriesConsumption: Int, dailyLiquidsConsumptionTarget: Int,
         dailyCaloriesConsumptionTarget: Int, dailyLiquidsConsumptions: Int, dailyCaloriesConsumptions: Int,
         gesturesDetection: Bool, developerMode: Bool, scheduleSettings: ScheduleSettings) {
        self.defaultLiquidsConsumption = defaultLiquidsConsumption
        self.defaultCaloriesConsumption = defaultCaloriesConsumption
        self.dailyLiquidsConsumptionTarget = dailyLiquidsConsumptionTarget
        self.dailyCaloriesConsumptionTarget = dailyCaloriesConsumptionTarget
        self.dailyLiquidsConsumptions = dailyLiquidsConsumptions
        self.dailyCaloriesConsumptions = dailyCaloriesConsumptions
        self.gesturesDetection = gesturesDetection
        self.developerMode = developerMode
        self.scheduleSettings = scheduleSettings
    }

    func saveToLocalData() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        if let encodedData = try? encoder.encode(self) {
            UserDefaults.standard.set(encodedData, forKey: "UserSettings")
        }
    }

    static func loadFromLocalData() -> UserSettings? {
        if let encodedData = UserDefaults.standard.data(forKey: "UserSettings") {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try? decoder.decode(UserSettings.self, from: encodedData)
        }
        return nil
    }
}
