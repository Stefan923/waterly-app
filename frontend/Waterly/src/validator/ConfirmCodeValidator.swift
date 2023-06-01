//
//  ConfirmCodeValidator.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

class ConfirmCodeValidator: Validator {
    private static let CONFIRM_CODE_PATTERN = "\\b\\d{6}\\b"
    
    func validate(_ value: Any) -> Bool {
        if let value = value as? String {
            let codePattern = ConfirmCodeValidator.CONFIRM_CODE_PATTERN
            
            let codePredicate = NSPredicate(format: "SELF MATCHES %@", codePattern)
            return codePredicate.evaluate(with: value)
        } else {
            return false
        }
    }
}
