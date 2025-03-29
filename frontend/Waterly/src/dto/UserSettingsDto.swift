//
//  UserSettingsDto.swift
//  Waterly
//
//  Created by Stefan Popescu on 14.06.2023.
//

import Foundation

class UserSettingsDto: ObservableObject, Codable {
    var userId: String
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
        case userId
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

    init(userId: String, defaultLiquidsConsumption: Int, defaultCaloriesConsumption: Int, dailyLiquidsConsumptionTarget: Int,
         dailyCaloriesConsumptionTarget: Int, dailyLiquidsConsumptions: Int, dailyCaloriesConsumptions: Int,
         gesturesDetection: Bool, developerMode: Bool, scheduleSettings: ScheduleSettings) {
        self.userId = userId
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
    
    init(userId: String, userSettings: UserSettings) {
        self.userId = userId
        self.defaultLiquidsConsumption = userSettings.defaultLiquidsConsumption
        self.defaultCaloriesConsumption = userSettings.defaultCaloriesConsumption
        self.dailyLiquidsConsumptionTarget = userSettings.dailyLiquidsConsumptionTarget
        self.dailyCaloriesConsumptionTarget = userSettings.dailyCaloriesConsumptionTarget
        self.dailyLiquidsConsumptions = userSettings.dailyLiquidsConsumptions
        self.dailyCaloriesConsumptions = userSettings.dailyCaloriesConsumptions
        self.gesturesDetection = userSettings.gesturesDetection
        self.developerMode = userSettings.developerMode
        self.scheduleSettings = userSettings.scheduleSettings
    }
}
