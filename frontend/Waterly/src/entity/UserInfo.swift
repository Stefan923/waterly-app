//
//  UserInfo.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

class UserInfo: Codable {
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var gender: GenderType
    var weight: Double
    var height: Double
    
    init(_ firstName: String, _ lastName: String, _ dateOfBirth: Date, _ gender: GenderType, _ weight: Double, _ height: Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.weight = weight
        self.height = height
    }
    
    func toJSON() -> [String: Any] {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "dateOfBirth": dateOfBirth.toDateString,
            "gender": gender.toString(),
            "weight": weight,
            "height": height
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case dateOfBirth
        case gender
        case weight
        case height
    }
}
