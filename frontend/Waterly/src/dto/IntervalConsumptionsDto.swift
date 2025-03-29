//
//  IntervalConsumptionsDto.swift
//  Waterly
//
//  Created by Stefan Popescu on 25.06.2023.
//

import Foundation

class IntervalConsumptionsDto: Codable {
    var consumptions: [IntervalConsumption]
    var currentPage: Int
    var totalItems: Int
    var totalPages: Int
    
    init(consumptions: [IntervalConsumption], currentPage: Int, totalItems: Int, totalPages: Int) {
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
