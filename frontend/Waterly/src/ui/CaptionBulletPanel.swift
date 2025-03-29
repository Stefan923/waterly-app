//
//  CaptionBulletPanel.swift
//  Waterly
//
//  Created by Stefan Popescu on 02.05.2023.
//

import SwiftUI

struct CaptionBulletPanel: View {
    var title : String
    @Binding var consumptions: [ConsumptionInfo]
    
    var body: some View {
        ZStack {
            RoundedCornersRectangle(radius: 0.08, corners: [.all])
                .fill(.white.shadow(.drop(radius: 2)))
            
            VStack {
                HStack {
                    Text(self.title)
                        .foregroundColor(Color("TextFieldFontColor"))
                        .font(.system(size: 19.0).weight(.semibold))
                        .frame(alignment: .leading)
                        .padding([.leading], 25.0)
                    Spacer(minLength: 0.0)
                }
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(consumptions, id: \.id) { consumption in
                            CaptionBullet(color: consumption.color, caption: consumption.caption)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding([.vertical], 16.0)
        }
    }
}

struct CaptionBulletPanel_Previews : PreviewProvider {
    static var previews: some View {
        let consumptions = [ConsumptionInfo("1", Color("RedBulletColor"), "08:30 AM"), ConsumptionInfo("2", Color("GreenBulletColor"), "09:00 AM"), ConsumptionInfo("3", Color("GreenBulletColor"), "09:30 AM"), ConsumptionInfo("4", Color("GreenBulletColor"), "10:00 AM"), ConsumptionInfo("5", Color("YellowBulletColor"), "10:30 AM"), ConsumptionInfo("6", Color("GreenBulletColor"), "11:00 AM"), ConsumptionInfo("7", Color("GreenBulletColor"), "11:30 AM"), ConsumptionInfo("8", Color("RedBulletColor"), "12:00 PM"), ConsumptionInfo("9", Color("GreenBulletColor"), "12:30 PM")]
        CaptionBulletPanel(title: "Drink liquids notification", consumptions: Binding.constant(consumptions))
            .frame(width: 320.0, height: 230.0)
    }
}
