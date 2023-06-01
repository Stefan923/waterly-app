//
//  SplashScreenView.swift
//  Waterly
//
//  Created by Stefan Popescu on 18.11.2022.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color("PrimaryColor")
                .ignoresSafeArea(.all)
            Image("waterly-text")
                .resizable()
                .frame(width: 300, height: 160)
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
