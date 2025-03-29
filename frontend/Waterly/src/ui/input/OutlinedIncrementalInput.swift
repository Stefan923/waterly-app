//
//  OutlinedIncrementalInput.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.06.2023.
//

import SwiftUI

struct OutlinedIncrementalInput : View {
    @Binding var value: Int
    let measureUnit: String
    let incrementStep: Int
    let minValue: Int
    let maxValue: Int
    let radius: CGFloat
    let corners: [RectangleCorner]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedCornersRectangle(radius: self.radius, corners: self.corners)
                    .fill(.white.shadow(.drop(radius: 2)))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                HStack(spacing: 0.0) {
                    Text(String("\(value) \(measureUnit)"))
                        .foregroundColor(Color("TextFieldFontColor"))
                        .font(.system(size: 17).weight(.semibold))
                        .frame(alignment: .leading)
                        .padding([.leading], 20.0)
                    
                    Spacer(minLength: 0.0)
                    
                    IconButton(icon: Image("minus-icon")) {
                        let newValue = value - incrementStep
                        if newValue >= minValue {
                            value = newValue
                        }
                    }
                    .frame(width: 32, height: 32, alignment: .trailing)
                    .padding([.trailing], 15.0)
                    
                    IconButton(icon: Image("plus-icon")) {
                        let newValue = value + incrementStep
                        if newValue <= maxValue {
                            value = newValue
                        }
                    }
                    .frame(width: 32, height: 32, alignment: .trailing)
                    .padding([.trailing], 20.0)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct OutlinedIncrementalInput_Previews : PreviewProvider {
    static var previews: some View {
        ZStack {
            OutlinedIncrementalInput(value: Binding.constant(0), measureUnit: "ml", incrementStep: 25, minValue: 0, maxValue: 2000, radius: 0.25, corners: [.all])
                .frame(width: 300.0, height: 60.0)
        }
    }
}
