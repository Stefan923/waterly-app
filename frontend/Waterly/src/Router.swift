//
//  Router.swift
//  drink-now
//
//  Created by Stefan Popescu on 27.03.2023.
//

import SwiftUI

final class Router: ObservableObject {

    @Published var navPath: NavigationPath = .init()
    
    func push(_ value: String) {
        navPath.append(value)
    }
    
    func pop() {
        navPath.removeLast()
    }
    
    func clear() {
        navPath.removeLast(navPath.count)
    }

}
