//
//  GoogleAuthentication.swift
//  Waterly
//
//  Created by Stefan Popescu on 13.05.2023.
//

import SwiftUI
import GoogleSignIn

class GoogleAuthentication {
    
    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        return false
    }
    
}
