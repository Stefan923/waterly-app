//
//  NameValidator.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

class NameValidator: Validator {
    private static let NAME_VALIDATOR_PATTERN = "[A-Za-z]+"

    func validate(_ value: Any) -> Bool {
        if let value = value as? String {
            let namePattern = NameValidator.NAME_VALIDATOR_PATTERN
            
            let namePredicate = NSPredicate(format: "SELF MATCHES %@", namePattern)
            return namePredicate.evaluate(with: value)
        } else {
            return false
        }
    }
}
