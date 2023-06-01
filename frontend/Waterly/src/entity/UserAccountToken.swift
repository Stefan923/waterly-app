//
//  UserAccountToken.swift
//  Waterly
//
//  Created by Stefan Popescu on 24.05.2023.
//

import Foundation

struct UserAccountToken: Decodable, Equatable {
    private var token: String
    
    init(token: String) {
        self.token = token
    }
    
    func getToken() -> String {
        return self.token
    }
}
