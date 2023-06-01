//
//  Validator.swift
//  Waterly
//
//  Created by Stefan Popescu on 26.05.2023.
//

import Foundation

protocol Validator {
    func validate(_ value: Any) -> Bool
}
