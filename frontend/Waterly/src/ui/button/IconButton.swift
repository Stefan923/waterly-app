//
//  IconButton.swift
//  Waterly
//
//  Created by Stefan Popescu on 17.04.2023.
//

import SwiftUI

struct IconButton: View {
    
    private var icon : Image?
    private var action : () -> Void
    
    init(icon: Image? = nil,
         action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color.white)
                    .opacity(0.20)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                icon?
                    .resizable()
                    .frame(width: geometry.size.width - 8, height: geometry.size.height - 8)
            }
        }
        .onTapGesture {
            self.action()
        }
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("PrimaryColor").ignoresSafeArea(.all)
            IconButton(icon: Image("settings")) {
                print("Ola!")
            }.frame(width: 38, height: 38)
        }
    }
}
