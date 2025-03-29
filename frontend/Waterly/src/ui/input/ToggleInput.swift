//
//  ToggleInput.swift
//  Waterly
//
//  Created by Stefan Popescu on 16.06.2023.
//

import SwiftUI

struct ToggleInput : View {
    private static let STEP_VALUE = 25
    
    @Binding var value: Bool
    let title: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0.0) {
                    Text(title)
                        .foregroundColor(Color("TextFieldFontColor"))
                        .font(.system(size: 17).weight(.semibold))
                        .frame(alignment: .leading)
                        .padding([.leading], 20.0)
                    
                    Spacer(minLength: 0.0)
                    
                    Toggle("", isOn: $value)
                        .labelsHidden()
                    .padding([.trailing], 20.0)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct ToggleInput_Previews : PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("TextFieldEdgeColor")
                .frame(width: 380.0, height: 60.0)
            ToggleInput(value: Binding.constant(false), title: "Enable developer mode")
                .frame(width: 380.0, height: 60.0)
        }
    }
}
