//
//  OutlinedTextFieldStyle.swift
//  drink-now
//
//  Created by Stefan Popescu on 28.03.2023.
//

import SwiftUI

struct OutlinedTextFieldStyle: TextFieldStyle {
    private let radius: CGFloat
    private let corners: [RectangleCorner]
    private var isWrongValue: Binding<Bool>
    
    init(radius: CGFloat = 0.30,
         corners: [RectangleCorner] = [],
         isWrongValue: Binding<Bool> = Binding.constant(false)) {
        self.radius = radius
        self.corners = corners
        self.isWrongValue = isWrongValue
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        GeometryReader { geometry in
            configuration
                .padding([.leading], 20)
                .foregroundColor(Color("TextFieldFontColor"))
                .background() {
                    if isWrongValue.wrappedValue {
                        RoundedCornersRectangle(radius: self.radius, corners: self.corners)
                            .fill(.white.shadow(.drop(radius: 2)))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        RoundedCornersRectangle(radius: self.radius, corners: self.corners)
                            .fill(Color("ErrorRedColor1").shadow(.drop(radius: 2)))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        RoundedCornersRectangle(radius: self.radius, corners: self.corners)
                            .fill(.white.shadow(.drop(radius: 2)))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .frame(height: geometry.size.height)
        }
    }
}

struct OutlinedTextFieldStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack(spacing: 0.0) {
                TextField("Type something...", text: .constant(""))
                    .textFieldStyle(OutlinedTextFieldStyle(corners: [.top]))
                    .frame(height: 60.0)
                TextField("Type something...", text: .constant(""))
                    .textFieldStyle(OutlinedTextFieldStyle(corners: [], isWrongValue: Binding.constant(true)))
                    .frame(height: 60.0)
                TextField("Type something...", text: .constant(""))
                    .textFieldStyle(OutlinedTextFieldStyle(corners: [.bottom]))
                    .frame(height: 60.0)
            }
            .padding([.horizontal], 40)
        }
    }
}
