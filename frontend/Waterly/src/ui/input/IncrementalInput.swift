//
//  IncrementalInput.swift
//  Waterly
//
//  Created by Stefan Popescu on 02.05.2023.
//

import SwiftUI

struct IncrementalInput : View {
    @State var value : Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0.0) {
                    Text(String("\(value) ml"))
                        .foregroundColor(Color("TextFieldFontColor"))
                        .font(.system(size: 17).weight(.semibold))
                        .frame(alignment: .leading)
                        .padding([.leading], 20.0)
                    
                    Spacer(minLength: 0.0)
                    
                    IconButton(icon: Image("minus-icon")) {
                        value = value - 1
                    }
                    .frame(width: 32, height: 32, alignment: .trailing)
                    .padding([.trailing], 15.0)
                    
                    IconButton(icon: Image("plus-icon")) {
                        value = value + 1
                    }
                    .frame(width: 32, height: 32, alignment: .trailing)
                    .padding([.trailing], 20.0)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct IncrementalInput_Previews : PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("TextFieldEdgeColor")
                .frame(width: 380.0, height: 60.0)
            IncrementalInput(value: 0)
                .frame(width: 380.0, height: 60.0)
        }
    }
}
