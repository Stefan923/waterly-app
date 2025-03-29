//
//  ConsumptionRequest.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.06.2023.
//

import Foundation

struct ConsumptionRequest: Codable {
    let userId: String
    var consumptionType: ConsumptionType
    var consumptionStatus: ConsumptionStatus
    var quantity: Float
    
    init(_ userId: String, _ consumptionType: ConsumptionType,
         _ consumptionStatus: ConsumptionStatus, _ quantity: Float) {
        self.userId = userId
        self.consumptionType = consumptionType
        self.consumptionStatus = consumptionStatus
        self.quantity = quantity
    }

    private enum CodingKeys: String, CodingKey {
        case userId
        case consumptionType
        case consumptionStatus
        case quantity
    }
}
