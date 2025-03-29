//
//  RoundedProgressView.swift
//  Waterly
//
//  Created by Stefan Popescu on 17.04.2023.
//

import SwiftUI

struct RoundedProgressView: View {
    private let title: String
    private let value: CGFloat
    
    init(title: String,
         value: CGFloat) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedCornersRectangle(radius: 0.23, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                    .fill(.white.shadow(.drop(radius: 2)))
                    .opacity(0.12)
                    .frame(width: geometry.size.width, height: 70.0)
                
                VStack(spacing: 0) {
                    HStack {
                        Text(title)
                            .foregroundColor(.white)
                            .font(.system(size: 20).weight(.regular))
                            .padding([.leading], 8)
                            .padding([.bottom], 6)
                            .frame(alignment: .leading)
                        
                        Spacer()
                    }
                    
                    ProgressView(value: self.value)
                        .progressViewStyle(RoundedProgressViewStyle(stroke: Color("ProgressViewStrokeColor"), fill: Color("PrimaryColor")))
                }
                .padding([.horizontal], 16)
            }
        }
        .frame(height: 70.0)
    }
}

struct RoundedProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("PrimaryColor")
                .ignoresSafeArea(.all)
            
            VStack {
                RoundedProgressView(title: "Daily water consumption target", value: 1.0)
                    .padding([.horizontal], 38)
                
                RoundedProgressView(title: "Daily calories consumption target", value: 0.5)
                    .padding([.horizontal], 38)
            }
        }
    }
}
