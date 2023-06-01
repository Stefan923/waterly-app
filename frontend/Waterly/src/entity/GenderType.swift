//
//  GenderType.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

enum GenderType {
    case male
    case female
    case other
}

extension GenderType {
    func toString() -> String {
        switch self {
        case .male:
            return "MALE"
        case .female:
            return "FEMALE"
        case .other:
            return "OTHER"
        }
    }
}
