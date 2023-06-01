//
//  UserAccountConfirmation.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

class UserAccountConfirmation {
    private var email: String
    private var confirmCode: String
    
    init(email: String, confirmCode: String) {
        self.email = email
        self.confirmCode = confirmCode
    }
    
    func getEmail() -> String {
        return email
    }
    
    func getConfirmCode() -> String {
        return confirmCode
    }
    
    func toJSON() -> [String: Any] {
        return [
            "email": email,
            "confirmCode": Int(confirmCode) ?? 0
        ]
    }
}
