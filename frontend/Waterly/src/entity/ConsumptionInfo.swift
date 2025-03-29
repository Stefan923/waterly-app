//
//  ConsumptionInfo.swift
//  Waterly
//
//  Created by Stefan Popescu on 18.06.2023.
//

import Foundation
import SwiftUI

class ConsumptionInfo: Identifiable {
    var id: String
    var caption: String
    var color: Color
    
    init(_ id: String, _ color: Color, _ caption: String) {
        self.id = id
        self.caption = caption
        self.color = color
    }
}
