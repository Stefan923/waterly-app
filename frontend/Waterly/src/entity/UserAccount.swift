//
//  UserAccount.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

class UserAccount: Equatable, Codable {
    var email: String
    var accountType: UserAccountType
    var o2authToken: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case accountType
        case o2authToken
        case password
    }
    
    init(email: String = "",
         accountType: UserAccountType = .credentials,
         o2authToken: String = "",
         password: String = "") {
        self.email = email
        self.accountType = accountType
        self.o2authToken = o2authToken
        self.password = password
    }
    
    func toJSON() -> [String: Any] {
        return [
            "accountType": accountType.toString(),
            "email": email,
            "o2authToken": o2authToken,
            "password": password
        ]
    }
    
    static func == (lhs: UserAccount, rhs: UserAccount) -> Bool {
        return lhs.email == rhs.email && lhs.o2authToken == rhs.o2authToken && lhs.password == rhs.password && lhs.accountType == rhs.accountType
    }
    
    func saveToLocalData() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        if let encodedData = try? encoder.encode(self) {
            UserDefaults.standard.set(encodedData, forKey: "UserAccount")
        }
    }

    static func loadFromLocalData() -> UserAccount? {
        if let encodedData = UserDefaults.standard.data(forKey: "UserAccount") {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try? decoder.decode(UserAccount.self, from: encodedData)
        }
        return nil
    }
}
