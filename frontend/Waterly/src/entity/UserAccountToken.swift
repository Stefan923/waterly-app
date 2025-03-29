//
//  UserAccountToken.swift
//  Waterly
//
//  Created by Stefan Popescu on 24.05.2023.
//

import Foundation

struct UserAccountToken: Decodable, Equatable {
    private var userId: String
    private var token: String
    
    init(userId: String, token: String) {
        self.userId = userId
        self.token = token
    }
    
    func getUserId() -> String {
        return self.userId
    }
    
    func getToken() -> String {
        return self.token
    }
}
