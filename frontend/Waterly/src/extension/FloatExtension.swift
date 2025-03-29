//
//  FloatExtension.swift
//  Waterly
//
//  Created by Stefan Popescu on 25.06.2023.
//

import Foundation

extension Float {
    func toString(consumptionType: ConsumptionType) -> String {
        if consumptionType == .LIQUID {
            if self >= 1000 {
                return String(format: "%.1f l", self / 1000).replacingOccurrences(of: ".0", with: "")
            }
            
            return String(format: "%.0f ml", self)
        } else {
            if self >= 1000 {
                return String(format: "%.1f kcal", self / 1000).replacingOccurrences(of: ".0", with: "")
            }
            
            return String(format: "%.0f cal", self)
        }
    }
}
