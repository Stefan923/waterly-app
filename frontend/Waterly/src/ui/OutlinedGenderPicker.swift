//
//  OutlinedGenderPicker.swift
//  Waterly
//
//  Created by Stefan Popescu on 25.06.2023.
//

import SwiftUI

struct OutlinedGenderPicker: View {
    private let title: String
    private var gender: Binding<GenderType>
    private let radius: CGFloat
    private let corners: [RectangleCorner]
    private var isWrongValue: Binding<Bool>
    
    init(title: String = "Gender",
         gender: Binding<GenderType>,
         radius: CGFloat = 0.30,
         corners: [RectangleCorner] = [],
         isWrongValue: Binding<Bool> = Binding.constant(false)) {
        self.title = title
        self.gender = gender
        self.radius = radius
        self.corners = corners
        self.isWrongValue = isWrongValue
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                
                HStack {
                    Text(self.title)
                        .foregroundColor(Color("TextFieldFontColor"))
                        .padding([.leading], 20)
                    
                    Spacer(minLength: 0)
                    
                    Picker("", selection: gender) {
                        Text("Male").tag(GenderType.MALE)
                        Text("Female").tag(GenderType.FEMALE)
                        Text("Other").tag(GenderType.OTHER)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200, alignment: .trailing)
                    .padding([.trailing], 20)
                }
            }
        }
        .frame(height: 60.0)
    }
}

struct OutlinedGenderPicker_Previews: PreviewProvider {
    static var previews: some View {
        @State var gender: GenderType = .MALE
        VStack(spacing: 0) {
            OutlinedGenderPicker(gender: $gender,
                               corners: [.top])
                .frame(width: 360)
            
            OutlinedGenderPicker(gender: $gender,
                               corners: [],
                               isWrongValue: Binding.constant(true))
                .frame(width: 360)
            
            OutlinedGenderPicker(gender: $gender,
                               corners: [.bottom])
                .frame(width: 360)
        }
    }
}
