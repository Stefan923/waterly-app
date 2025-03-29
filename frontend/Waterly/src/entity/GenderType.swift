//
//  GenderType.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

enum GenderType : String, Codable {
    case MALE
    case FEMALE
    case OTHER
}

extension GenderType {
    func toString() -> String {
        switch self {
        case .MALE:
            return "MALE"
        case .FEMALE:
            return "FEMALE"
        case .OTHER:
            return "OTHER"
        }
    }
    
    func toStringWithFirstUpper() -> String {
        switch self {
        case .MALE:
            return "Male"
        case .FEMALE:
            return "Female"
        case .OTHER:
            return "Other"
        }
    }
}
