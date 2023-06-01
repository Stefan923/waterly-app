//
//  EmailValidator.swift
//  Waterly
//
//  Created by Stefan Popescu on 26.05.2023.
//

import Foundation

class EmailValidator: Validator {
    private static let EMAIL_VALIDATOR_PATTERN = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    func validate(_ value: Any) -> Bool {
        if let value = value as? String {
            let emailPattern = EmailValidator.EMAIL_VALIDATOR_PATTERN
            
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
            return emailPredicate.evaluate(with: value)
        } else {
            return false
        }
    }
}
