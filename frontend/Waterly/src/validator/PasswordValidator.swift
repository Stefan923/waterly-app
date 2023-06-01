//
//  PasswordValidator.swift
//  Waterly
//
//  Created by Stefan Popescu on 26.05.2023.
//

import Foundation

class PasswordValidator: Validator {
    private static let MIN_LENGTH = 8
    private static let MAX_LENGTH = 32
    private static let AT_LEAST_ONE_UPPERCASE_LETTER = ".*[A-Z]+.*"
    private static let AT_LEAST_ONE_LOWERCASE_LETTER = ".*[a-z]+.*"
    private static let AT_LEAST_ONE_DIGIT = ".*\\d+.*"
    
    func validate(_ value: Any) -> Bool {
        if let value = value as? String {
            // Check if the password meets the length requirement
            if value.count < PasswordValidator.MIN_LENGTH || value.count > PasswordValidator.MAX_LENGTH {
                return false
            }
            
            // Check if the password contains at least one uppercase letter
            let uppercaseLetterRegex = PasswordValidator.AT_LEAST_ONE_UPPERCASE_LETTER
            let uppercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseLetterRegex)
            guard uppercaseLetterPredicate.evaluate(with: value) else {
                return false
            }
            
            // Check if the password contains at least one lowercase letter
            let lowercaseLetterRegex = PasswordValidator.AT_LEAST_ONE_LOWERCASE_LETTER
            let lowercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", lowercaseLetterRegex)
            guard lowercaseLetterPredicate.evaluate(with: value) else {
                return false
            }
            
            // Check if the password contains at least one digit
            let digitRegex = PasswordValidator.AT_LEAST_ONE_DIGIT
            let digitPredicate = NSPredicate(format: "SELF MATCHES %@", digitRegex)
            guard digitPredicate.evaluate(with: value) else {
                return false
            }
            
            return true
        } else {
            return false
        }
    }
}
