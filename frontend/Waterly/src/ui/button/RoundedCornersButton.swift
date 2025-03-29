//
//  RoundedCornersButton.swift
//  Waterly
//
//  Created by Stefan Popescu on 04.05.2023.
//

import SwiftUI

struct RoundedCornersButton : View {
    private var title : String
    private var titleColor : Color
    private var centerTitle : Bool
    private var radius : CGFloat
    private var corners : [RectangleCorner]
    private var buttonWidth : CGFloat
    private var displayIcon : Bool
    private var action : () -> Void
    
    init(title: String = "",
         titleColor: Color = Color("TextFieldFontColor"),
         centerTitle: Bool = false,
         radius: CGFloat = 0.10,
         corners: [RectangleCorner] = [.all],
         buttonWidth: CGFloat = 380,
         displayIcon: Bool = true,
         action: @escaping () -> Void
    ) {
        self.title = title
        self.titleColor = titleColor
        self.centerTitle = centerTitle
        self.radius = radius
        self.corners = corners
        self.buttonWidth = buttonWidth
        self.displayIcon = displayIcon
        self.action = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0.0) {
                    ZStack {
                        RoundedCornersRectangle(radius: self.radius, corners: self.corners)
                            .fill(.white.shadow(.drop(radius: 2)))
                        
                        HStack {
                            if centerTitle {
                                Spacer(minLength: 0.0)
                                
                                Text(self.title)
                                    .foregroundColor(self.titleColor)
                                    .font(.system(size: 19.0).weight(.regular))
                                    .frame(alignment: .center)
                            } else {
                                Text(self.title)
                                    .foregroundColor(self.titleColor)
                                    .font(.system(size: 19.0).weight(.regular))
                                    .frame(alignment: .leading)
                                    .padding([.leading], 20.0)
                            }
                            
                            Spacer(minLength: 0.0)
                            
                            if displayIcon {
                                Image("down-chevron")
                                    .resizable()
                                    .rotationEffect(Angle(degrees: 270.0))
                                    .frame(width: 30, height: 30)
                                    .padding([.trailing], 20.0)
                            }
                        }
                    }
                    .frame(height: 60.0, alignment: .top)
                    
                    Spacer(minLength: 0.0)
                }
            }
        }
        .frame(width: self.buttonWidth, height: 60.0)
        .onTapGesture {
            self.action()
        }
    }
}

struct RoundedCornersButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.white).ignoresSafeArea(.all)
            
            VStack(spacing: 30.0) {
                VStack(spacing: 0.0) {
                    RoundedCornersButton(title: "Liquids consumption statistics", radius: 0.30, corners: [.top]) {
                        print("Ola!")
                    }
                    RoundedCornersButton(title: "Calories consumption statistics", radius: 0.30, corners: []) {
                        print("Ola!")
                    }
                    RoundedCornersButton(title: "Uncertain gestures", radius: 0.30, corners: [.bottom]) {
                        print("Ola!")
                    }
                }
                
                RoundedCornersButton(title: "Sign out", titleColor: .red, centerTitle: true, radius: 0.30, corners: [.all], displayIcon: false) {
                    print("Ola!")
                }
            }
        }
    }
}
