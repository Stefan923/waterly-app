//
//  WaveEdgedRectangle.swift
//  drink-now
//
//  Created by Stefan Popescu on 12.03.2023.
//

import SwiftUI

struct WaveEdgedRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                      control1: CGPoint(x: rect.maxX * 0.28, y: 80),
                      control2: CGPoint(x: rect.maxX * 0.66, y: -80))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct WaveEdgedRectangle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            WaveEdgedRectangle()
                .stroke(Color("PrimaryColor"), lineWidth: 5.0)
                .shadow(radius: 48.0)
                .frame(height: 600.0)
        }
    }
}
