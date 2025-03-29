//
//  IntervalConsumption.swift
//  Waterly
//
//  Created by Stefan Popescu on 25.06.2023.
//

import Foundation

struct IntervalConsumption: Codable, Identifiable {
    private static var ID_SEQUENCE = 0
    
    let id: Int
    let time: Date
    var quantity: Float
    var animate: Bool = false
    
    init(time: Date, quantity: Float) {
        self.id = IntervalConsumption.ID_SEQUENCE
        self.time = time
        self.quantity = quantity
        
        IntervalConsumption.ID_SEQUENCE += 1
    }
    
    private enum CodingKeys: String, CodingKey {
        case time
        case quantity
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = IntervalConsumption.ID_SEQUENCE
        time = try container.decode(Date.self, forKey: .time)
        quantity = try container.decode(Float.self, forKey: .quantity)
        
        IntervalConsumption.ID_SEQUENCE += 1
    }
}
