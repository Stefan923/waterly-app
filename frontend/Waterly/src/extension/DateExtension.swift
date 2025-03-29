//
//  DateExtension.swift
//  Waterly
//
//  Created by Stefan Popescu on 25.06.2023.
//

import Foundation

extension Date {
    var toDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter.string(from: self)
    }
    
    var toTitle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMM dd, HH:mm a"

        return dateFormatter.string(from: self)
    }
}
