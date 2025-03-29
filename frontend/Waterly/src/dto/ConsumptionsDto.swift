//
//  ConsumptionsDto.swift
//  Waterly
//
//  Created by Stefan Popescu on 18.06.2023.
//

import Foundation

class ConsumptionsDto: Codable {
    var consumptions: [Consumption]
    var currentPage: Int
    var totalItems: Int
    var totalPages: Int
    
    init(consumptions: [Consumption], currentPage: Int, totalItems: Int, totalPages: Int) {
        self.consumptions = consumptions
        self.currentPage = currentPage
        self.totalItems = totalItems
        self.totalPages = totalPages
    }
    
    private enum CodingKeys: String, CodingKey {
        case consumptions
        case currentPage
        case totalItems
        case totalPages
    }
}
