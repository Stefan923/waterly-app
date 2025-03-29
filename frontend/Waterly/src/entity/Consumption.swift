//
//  Consumption.swift
//  Waterly
//
//  Created by Stefan Popescu on 18.06.2023.
//

import Foundation

struct Consumption: Codable, Equatable, Identifiable {
    let id: String
    let consumptionType: ConsumptionType
    var consumptionStatus: ConsumptionStatus
    var quantity: Float
    let createdAt: Date
    var modifiedAt: Date
    var animate: Bool = false
    
    init(id: String, consumptionType: ConsumptionType, consumptionStatus: ConsumptionStatus, quantity: Float, createdAt: Date, modifiedAt: Date) {
        self.id = id
        self.consumptionType = consumptionType
        self.consumptionStatus = consumptionStatus
        self.quantity = quantity
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case consumptionType
        case consumptionStatus
        case quantity
        case createdAt
        case modifiedAt
    }
}
