//
//  UserAccountTokenManager.swift
//  Waterly
//
//  Created by Stefan Popescu on 02.06.2023.
//

import Foundation

class UserAccountTokenManager {
    static let shared = UserAccountTokenManager()
    private var userAccountToken: UserAccountToken?

    private init() {}

    func setUserAccountToken(_ token: UserAccountToken) {
        userAccountToken = token
    }

    func getUserAccountToken() -> UserAccountToken? {
        return userAccountToken
    }
}
