//
//  TimeRange.swift
//  Waterly
//
//  Created by Stefan Popescu on 12.06.2023.
//

import Foundation

struct TimeRange: Codable {
    var startHour: Time
    var endHour: Time

    init(startHour: Time, endHour: Time) {
        self.startHour = startHour
        self.endHour = endHour
    }
    
    private enum CodingKeys: String, CodingKey {
        case startHour
        case endHour
    }
}
