//
//  SpinningCircle.swift
//  Waterly
//
//  Created by Stefan Popescu on 26.05.2023.
//

import SwiftUI

struct SpinningCircle: View {
    private static let CIRCLE_LINE_WIDTH = CGFloat(20)
    
    private let trimFrom: CGFloat
    private let trimTo: CGFloat
    private let rotation: Angle
    private let color: Color
    
    init(trimFrom: CGFloat, trimTo: CGFloat, rotation: Angle, color: Color) {
        self.trimFrom = trimFrom
        self.trimTo = trimTo
        self.rotation = rotation
        self.color = color
    }

    var body: some View {
        Circle()
            .trim(from: trimFrom, to: trimTo)
            .stroke(style: StrokeStyle(lineWidth: SpinningCircle.CIRCLE_LINE_WIDTH, lineCap: .round))
            .fill(color)
            .rotationEffect(rotation)
    }
}

struct SpinningCircle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack (spacing: 50.0) {
                SpinningCircle(trimFrom: 0.0, trimTo: 0.25, rotation: .degrees(270), color: .gray)
                SpinningCircle(trimFrom: 0.0, trimTo: 0.5, rotation: .degrees(270), color: .gray)
                SpinningCircle(trimFrom: 0.0, trimTo: 1.0, rotation: .degrees(270), color: .gray)
            }
            .frame(width: 100, height: 400)
        }
    }
}
