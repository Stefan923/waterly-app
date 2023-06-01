//
//  RoundedCornersRectangle.swift
//  drink-now
//
//  Created by Stefan Popescu on 09.04.2023.
//

import SwiftUI

struct RoundedCornersRectangle: Shape {
    private let radius: CGFloat
    private let corners: [RectangleCorner]
    
    init(radius: CGFloat = 0.30, corners: [RectangleCorner] = []) {
        self.radius = radius
        self.corners = corners
    }
    
    func path(in rect: CGRect) -> Path {
        let cornerRadius = rect.maxY * self.radius
        
        var path = Path()
        
        if (corners.contains(.topLeft) || corners.contains(.top) || corners.contains(.all)) {
            path.move(to: CGPoint(x: 0, y: cornerRadius))
            path.addQuadCurve(to: CGPoint(x: cornerRadius, y: rect.minY),
                              control: CGPoint(x: rect.minX, y: rect.minY))
        } else {
            path.move(to: .zero)
        }
        
        if (corners.contains(.topRight) || corners.contains(.top) || corners.contains(.all)) {
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
                              control: CGPoint(x: rect.maxX, y: rect.minY))
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
        
        if (corners.contains(.bottomRight) || corners.contains(.bottom) || corners.contains(.all)) {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addQuadCurve(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY),
                              control: CGPoint(x: rect.maxX, y: rect.maxY))
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
        
        if (corners.contains(.bottomLeft) || corners.contains(.bottom) || corners.contains(.all)) {
            path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius),
                              control: CGPoint(x: rect.minX, y: rect.maxY))
        } else {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        
        path.closeSubpath()
        return path
    }
}

struct RoundedCornersRectangle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                RoundedCornersRectangle(radius: 0.30, corners: [.topLeft, .topRight])
                    .stroke(Color("TextFieldEdgeColor"), lineWidth: 1.0)
                    .shadow(radius: 48.0)
                    .frame(width: 360.0, height: 70.0)
                
                RoundedCornersRectangle(radius: 0.30)
                    .stroke(Color("TextFieldEdgeColor"), lineWidth: 1.0)
                    .shadow(radius: 48.0)
                    .frame(width: 360.0, height: 70.0)
                
                RoundedCornersRectangle(radius: 0.30, corners: [.bottomLeft, .bottomRight])
                    .stroke(Color("TextFieldEdgeColor"), lineWidth: 1.0)
                    .shadow(radius: 48.0)
                    .frame(width: 360.0, height: 70.0)
            }
        }
    }
}
