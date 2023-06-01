//
//  WeightHeightValidator.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

class WeightHeightValidator: Validator {
    private static let WEIGHT_HEIGHT_VALIDATOR_MIN = 0.0
    private static let WEIGHT_HEIGHT_VALIDATOR_MAX = 1000.0

    func validate(_ value: Any) -> Bool {
        if let value = value as? Double {
            return value >= WeightHeightValidator.WEIGHT_HEIGHT_VALIDATOR_MIN && value <= WeightHeightValidator.WEIGHT_HEIGHT_VALIDATOR_MAX
        } else {
            return false
        }
    }
}
