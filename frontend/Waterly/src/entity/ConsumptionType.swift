//
//  ConsumptionType.swift
//  Waterly
//
//  Created by Stefan Popescu on 18.06.2023.
//

import Foundation

enum ConsumptionType: String, Codable {
    case LIQUID
    case FOOD
}

extension ConsumptionType {
    func toString() -> String {
        switch self {
        case .LIQUID:
            return "LIQUID"
        case .FOOD:
            return "FOOD"
        }
    }
}
