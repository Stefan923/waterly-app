//
//  UserAccount.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

class UserAccount: Equatable {
    private var email: String
    private var accountType: UserAccountType
    private var password: String
    
    init(_ email: String = "",
         _ accountType: UserAccountType = .credentials,
         _ password: String = "") {
        self.email = email
        self.accountType = accountType
        self.password = password
    }
    
    func getEmail() -> String {
        return self.email
    }
    
    func setEmail(_ email: String) -> Void {
        self.email = email
    }
    
    func getAccountType() -> UserAccountType {
        return self.accountType
    }
    
    func setAccountType(_ accountType: UserAccountType) -> Void {
        self.accountType = accountType
    }
    
    func getPassword() -> String {
        return self.password
    }
    
    func setPassword(_ password: String) -> Void {
        self.password = password
    }
    
    func toJSON() -> [String: Any] {
        return [
            "accountType": accountType.toString(),
            "email": email,
            "password": password
        ]
    }
    
    static func == (lhs: UserAccount, rhs: UserAccount) -> Bool {
        return lhs.email == rhs.email && lhs.password == rhs.password && lhs.accountType == rhs.accountType
    }
}
