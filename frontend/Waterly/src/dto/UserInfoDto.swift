//
//  UserInfoDto.swift
//  Waterly
//
//  Created by Stefan Popescu on 01.07.2023.
//

import Foundation

struct UserInfoDto: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let dateOfBirth: Date
    let gender: GenderType
    let weight: Double
    let height: Double
    
    init(userId: String, userInfo: UserInfo) {
        self.userId = userId
        self.firstName = userInfo.firstName
        self.lastName = userInfo.lastName
        self.dateOfBirth = userInfo.dateOfBirth
        self.gender = userInfo.gender
        self.weight = userInfo.weight
        self.height = userInfo.height
    }
    
    enum CodingKeys: String, CodingKey {
        case userId
        case firstName
        case lastName
        case dateOfBirth
        case gender
        case weight
        case height
    }
}
