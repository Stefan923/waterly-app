//
//  Time.swift
//  Waterly
//
//  Created by Stefan Popescu on 13.06.2023.
//

import Foundation

struct Time: Codable {
    var hour: Int
    var minute: Int

    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
    private enum CodingKeys: String, CodingKey {
        case hour
        case minute
    }
}
