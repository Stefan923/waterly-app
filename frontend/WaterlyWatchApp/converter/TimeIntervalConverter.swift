//
//  TimeIntervalConverter.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 19.06.2023.
//

import Foundation

class TimeIntervalConverter {
    static func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]

        guard let formattedString = formatter.string(from: timeInterval) else {
            return ""
        }

        return formattedString
    }
}
