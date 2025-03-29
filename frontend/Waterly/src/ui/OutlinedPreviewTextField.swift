//
//  OutlinedPreviewTextField.swift
//  Waterly
//
//  Created by Stefan Popescu on 01.07.2023.
//

import SwiftUI

struct OutlinedPreviewTextField: View {
    private let key: String
    private let value: String
    private let radius: CGFloat
    private let corners: [RectangleCorner]
    
    init(key: String,
         value: String,
         radius: CGFloat = 0.30,
         corners: [RectangleCorner] = []) {
        self.key = key
        self.value = value
        self.radius = radius
        self.corners = corners
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                RoundedCornersRectangle(radius: self.radius, corners: self.corners)
                    .fill(.white.shadow(.drop(radius: 2)))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                HStack {
                    Text(self.key)
                        .foregroundColor(Color("TextFieldFontColor"))
                    
                    Spacer(minLength: 0)
                    
                    Text(self.value)
                        .foregroundColor(Color("TextFieldFontColor"))
                        .opacity(0.65)
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(height: 52.0)
    }
}

struct OutlinedPreviewTextField_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedDate = Date()
        VStack(spacing: 0) {
            OutlinedPreviewTextField(key: "First name:", value: "John", corners: [.top])
                .frame(width: 360)
            
            OutlinedPreviewTextField(key: "Last name:", value: "Smith")
                .frame(width: 360)
            
            OutlinedPreviewTextField(key: "Date of birth:", value: "2000-06-04", corners: [.bottom])
                .frame(width: 360)
        }
    }
}
