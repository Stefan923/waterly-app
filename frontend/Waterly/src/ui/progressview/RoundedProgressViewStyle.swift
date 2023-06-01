//
//  RoundedProgressViewStyle.swift
//  Waterly
//
//  Created by Stefan Popescu on 17.04.2023.
//

import SwiftUI

struct RoundedProgressViewStyle<Stroke: ShapeStyle, Background: ShapeStyle>: ProgressViewStyle {
    var stroke: Stroke
    var fill: Background
    var caption: String = ""
    var cornerRadius: CGFloat = 10
    var height: CGFloat = 20
    var animation: Animation = .easeInOut
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        var textPadding = 0
        
        if fractionCompleted > 0.1 && fractionCompleted < 1.0 {
            textPadding =  42
        } else if fractionCompleted == 1.0 {
            textPadding = 52
        }
        
        return VStack {
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    let progressSize = geo.size.width * CGFloat(fractionCompleted)
                    
                    Rectangle()
                        .fill(stroke)
                        .frame(maxWidth: geo.size.width)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(fill)
                        .frame(maxWidth: progressSize)
                        .animation(animation)
                    
                    if textPadding != 0 {
                        Text(String(format: "%.0f%%", fractionCompleted * 100))
                            .foregroundColor(.white)
                            .padding([.leading], progressSize - CGFloat(textPadding))
                    }
                }
            }
            .frame(height: height)
            .cornerRadius(cornerRadius)
            
            if !caption.isEmpty {
                Text("\(caption)")
                    .font(.caption)
            }
        }
    }
}

struct RoundedProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ProgressView(value: 1.0)
                .progressViewStyle(RoundedProgressViewStyle(stroke: Color("ProgressViewStrokeColor"), fill: Color("PrimaryColor")))
                .padding([.horizontal], 32)
        }
    }
}
