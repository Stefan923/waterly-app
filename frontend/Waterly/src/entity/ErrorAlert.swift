//
//  ErrorAlert.swift
//  Waterly
//
//  Created by Stefan Popescu on 24.05.2023.
//

import Foundation

struct ErrorAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}
