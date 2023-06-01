//
//  UserInfo.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import Foundation

class UserInfo {
    private var firstName: String
    private var lastName: String
    private var dateOfBirth: Date
    private var gender: GenderType
    private var weight: Double
    private var height: Double
    
    init(_ firstName: String, _ lastName: String, _ dateOfBirth: Date, _ gender: GenderType, _ weight: Double, _ height: Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.weight = weight
        self.height = height
    }
    
    func getFirstName() -> String {
        return firstName
    }
    
    func getLastName() -> String {
        return lastName
    }
    
    func getDateOfBirth() -> Date {
        return dateOfBirth
    }
    
    func getGender() -> GenderType {
        return gender
    }
    
    func getWeight() -> Double {
        return weight
    }
    
    func getHeight() -> Double {
        return height
    }
    
    func toJSON() -> [String: Any] {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "dateOfBirth": DateStringConverter.convertDateToString(dateOfBirth),
            "gender": gender.toString(),
            "weight": weight,
            "height": height
        ]
    }
}
