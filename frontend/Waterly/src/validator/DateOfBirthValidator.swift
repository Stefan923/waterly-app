//
//  DateOfBirthValidator.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

class DateOfBirthValidator: Validator {
    private static let MINIMUM_AGE = 7

    func validate(_ value: Any) -> Bool {
        if let date = value as? Date {
            let calendar = Calendar.current
            let currentDate = Date()
            let minimumDate = calendar.date(byAdding: .year, value: -DateOfBirthValidator.MINIMUM_AGE, to: currentDate)!
            
            return date <= minimumDate
        }
        
        return false
    }
}
