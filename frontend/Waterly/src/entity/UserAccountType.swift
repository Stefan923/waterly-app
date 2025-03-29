//
//  UserAccountType.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

enum UserAccountType: String, Codable {
    case credentials
    case google
    case appleID
}

extension UserAccountType {
    func toString() -> String {
        switch self {
        case .credentials:
            return "CREDENTIALS"
        case .google:
            return "GOOGLE"
        case .appleID:
            return "APPLE_ID"
        }
    }
}
