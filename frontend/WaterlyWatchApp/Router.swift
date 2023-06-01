//
//  Router.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 06.05.2023.
//

import WatchKit
import SwiftUI

final class Router: ObservableObject {

    @Published var navPath: NavigationPath = .init()
    
    func push(_ value: String) {
        navPath.append(value)
    }
    
    func pop() {
        navPath.removeLast()
    }

}
