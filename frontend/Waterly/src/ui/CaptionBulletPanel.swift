//
//  CaptionBulletPanel.swift
//  Waterly
//
//  Created by Stefan Popescu on 02.05.2023.
//

import SwiftUI

struct CaptionBulletPanel : View {
    var title : String
    var colors : [Color]
    var captions : [String]
    
    var body: some View {
        ZStack {
            RoundedCornersRectangle(radius: 0.08, corners: [.all])
                .fill(Color("TextFieldFillColor"),
                      strokeBorder: Color("TextFieldEdgeColor"),
                      lineWidth: 1.0)
            
            ScrollView(.vertical) {
                VStack {
                    HStack {
                        Text(self.title)
                            .foregroundColor(Color("TextFieldFontColor"))
                            .font(.system(size: 19.0).weight(.semibold))
                            .frame(alignment: .leading)
                            .padding([.leading], 25.0)
                        Spacer(minLength: 0.0)
                    }
                    
                    ForEach(0..<((colors.count / 3) + 1)) { i in
                        HStack(spacing: 15.0) {
                            ForEach((i * 3)..<(min((i + 1) * 3, colors.count))) { j in
                                CaptionBullet(color: colors[j], caption: captions[j])
                            }
                        }
                    }
                }
            }
            .padding([.vertical], 20.0)
        }
    }
}

struct CaptionBulletPanel_Previews : PreviewProvider {
    static var previews: some View {
        let colors = [Color("RedBulletColor"), Color("GreenBulletColor"), Color("GreenBulletColor"), Color("GreenBulletColor"), Color("YellowBulletColor"), Color("GreenBulletColor"), Color("GreenBulletColor"), Color("RedBulletColor"), Color("GreenBulletColor")]
        let captions = ["09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "12:30 PM"]
        CaptionBulletPanel(title: "Drink liquids notification", colors: colors, captions: captions)
            .frame(width: 320.0, height: 220.0)
    }
}
