//
//  ConsumptionStatuts.swift
//  Waterly
//
//  Created by Stefan Popescu on 18.06.2023.
//

import Foundation

enum ConsumptionStatus: String, Codable {
    case DONE
    case POSTPHONED
    case CANCELED
    case NO_ENTRY
}

extension ConsumptionStatus {
    static func parseValue(value: String) -> ConsumptionStatus {
        switch value {
        case "DONE":
            return .DONE
        case "POSTPHONED":
            return .POSTPHONED
        case "CANCELED":
            return .CANCELED
        default:
            return .NO_ENTRY
        }
    }
}
