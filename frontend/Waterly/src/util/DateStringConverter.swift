//
//  DateStringConverter.swift
//  Waterly
//
//  Created by Stefan Popescu on 29.05.2023.
//

import Foundation

class DateStringConverter {
    static func convertDateToString(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
}
