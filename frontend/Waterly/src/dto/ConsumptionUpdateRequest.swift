//
//  ConsumptionUpdateRequest.swift
//  Waterly
//
//  Created by Stefan Popescu on 20.06.2023.
//

import Foundation

struct ConsumptionUpdateRequest: Codable {
    let id: String
    var consumptionStatus: ConsumptionStatus
    var quantity: Float
    
    init(id: String, consumptionStatus: ConsumptionStatus, quantity: Float) {
        self.id = id
        self.consumptionStatus = consumptionStatus
        self.quantity = quantity
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case consumptionStatus
        case quantity
    }
}
