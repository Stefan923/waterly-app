//
//  DropdownButton.swift
//  Waterly
//
//  Created by Stefan Popescu on 01.05.2023.
//

import SwiftUI

struct DropdownButton<Content: View> : View {
    private var title : String
    private var radius : CGFloat
    private var corners : [RectangleCorner]
    private var expandedCorners : [RectangleCorner]
    private var buttonWidth : CGFloat
    
    @ViewBuilder private var content: () -> Content
    
    @State var rotationAngle : CGFloat = 0.0
    @State var isActive : Bool = false
    @State var isInputActive : Bool = false
    @State var height : CGFloat = 60.0
    
    init(title: String = "",
         radius: CGFloat = 0.10,
         corners: [RectangleCorner] = [.all],
         expandedCorners: [RectangleCorner] = [.all],
         buttonWidth: CGFloat = 380,
         @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.radius = radius
        self.corners = corners
        self.expandedCorners = expandedCorners
        self.buttonWidth = buttonWidth
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if (isActive) {
                    RoundedCornersRectangle(radius: self.radius, corners: self.expandedCorners)
                        .fill(Color("TextFieldFillColor"),
                              strokeBorder: Color("TextFieldEdgeColor"),
                              lineWidth: 1.0)
                        .frame(height: height)
                }
                
                ZStack {
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        
                        self.content().frame(height: 60.0, alignment: .bottom)
                    }
                    
                    VStack(spacing: 0.0) {
                        ZStack {
                            RoundedCornersRectangle(radius: self.radius, corners: self.corners)
                                .fill(Color("TextFieldFillColor"),
                                      strokeBorder: Color("TextFieldEdgeColor"),
                                      lineWidth: 1.0)
                            
                            HStack {
                                Text(self.title)
                                    .foregroundColor(Color("TextFieldFontColor"))
                                    .font(.system(size: 19.0).weight(.regular))
                                    .frame(alignment: .leading)
                                    .padding([.leading], 20.0)
                                
                                Spacer()
                                
                                Image("down-chevron")
                                    .resizable()
                                    .rotationEffect(Angle(degrees: self.rotationAngle))
                                    .frame(width: 30, height: 30)
                                    .padding([.trailing], 20.0)
                            }
                        }
                        .frame(height: 60.0, alignment: .top)
                        
                        Spacer(minLength: 0.0)
                    }
                }
                .frame(height: height)
            }
        }
        .frame(width: self.buttonWidth, height: height)
        .onTapGesture {
            self.toggleDropdown()
        }
    }
    
    private func toggleDropdown() {
        if (!self.isActive) {
            withAnimation(.easeInOut(duration: 0.0)) {
                self.isActive.toggle()
            }
            withAnimation(.easeInOut(duration: 0.3)) {
                self.height = 120.0
                self.rotationAngle = 180.0
            }
        } else {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.height = 60.0
                self.rotationAngle = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.0)) {
                    self.isActive.toggle()
                }
            }
        }
    }
}

struct DropdownButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.white).ignoresSafeArea(.all)
            VStack(spacing: 0.0) {
                DropdownButton<IncrementalInput>(title: "Default water consumption", radius: 0.30, corners: [.top], expandedCorners: [.top]) {
                    IncrementalInput(value: 0)
                }
                    .frame(alignment: .top)
                DropdownButton<IncrementalInput>(title: "Default calories consumption", radius: 0.30, corners: [], expandedCorners: []) {
                    IncrementalInput(value: 0)
                }
                    .frame(alignment: .top)
                DropdownButton<IncrementalInput>(title: "Other user details", radius: 0.30, corners: [.bottom], expandedCorners: [.bottom]) {
                    IncrementalInput(value: 0)
                }
                    .frame(alignment: .top)
                Spacer()
            }
        }
    }
}
