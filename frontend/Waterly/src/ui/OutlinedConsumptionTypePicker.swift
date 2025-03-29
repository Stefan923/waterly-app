//
//  OutlinedConsumptionTypePicker.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.06.2023.
//

import SwiftUI

struct OutlinedConsumptionTypePicker: View {
    private let title: String
    private var consumptionType: Binding<ConsumptionType>
    private let radius: CGFloat
    private let corners: [RectangleCorner]
    private var isWrongValue: Binding<Bool>
    
    init(title: String = "Consumption type",
         consumptionType: Binding<ConsumptionType>,
         radius: CGFloat = 0.30,
         corners: [RectangleCorner] = [],
         isWrongValue: Binding<Bool> = Binding.constant(false)) {
        self.title = title
        self.consumptionType = consumptionType
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
                    
                    Picker("", selection: consumptionType) {
                        Text("Liquids").tag(ConsumptionType.LIQUID)
                        Text("Calories").tag(ConsumptionType.FOOD)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 160, alignment: .trailing)
                    .padding([.trailing], 20)
                }
            }
        }
        .frame(height: 60.0)
    }
}

struct OutlinedConsumptionTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        @State var consumptionType: ConsumptionType = .LIQUID
        VStack(spacing: 0) {
            OutlinedConsumptionTypePicker(consumptionType: $consumptionType,
                               corners: [.top])
                .frame(width: 360)
            
            OutlinedConsumptionTypePicker(consumptionType: $consumptionType,
                               corners: [],
                               isWrongValue: Binding.constant(true))
                .frame(width: 360)
            
            OutlinedConsumptionTypePicker(consumptionType: $consumptionType,
                               corners: [.bottom])
                .frame(width: 360)
        }
    }
}
