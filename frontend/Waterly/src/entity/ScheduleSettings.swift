//
//  ScheduleSettings.swift
//  Waterly
//
//  Created by Stefan Popescu on 12.06.2023.
//

import Foundation

struct ScheduleSettings: Codable {
    var monday: TimeRange
    var tuesday: TimeRange
    var wednesday: TimeRange
    var thursday: TimeRange
    var friday: TimeRange
    var saturday: TimeRange
    var sunday: TimeRange

    init(monday: TimeRange, tuesday: TimeRange, wednesday: TimeRange, thursday: TimeRange, friday: TimeRange, saturday: TimeRange, sunday: TimeRange) {
        self.sunday = sunday
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
    }
    
    private enum CodingKeys: String, CodingKey {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
}
