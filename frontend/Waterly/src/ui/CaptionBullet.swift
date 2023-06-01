//
//  CaptionBullet.swift
//  Waterly
//
//  Created by Stefan Popescu on 02.05.2023.
//

import SwiftUI

struct CaptionBullet : View {
    var color: Color
    var caption: String
    
    var body: some View {
        VStack {
            Circle()
                .fill(color)
                .frame(width: 16.0, height: 16.0)
            Text(caption)
                .foregroundColor(Color("TextFieldFontColor"))
        }.frame(width: 80, height: 50)
    }
}

struct CaptionBullet_Previews : PreviewProvider {
    static var previews: some View {
        ZStack {
            HStack {
                CaptionBullet(color: Color("GreenBulletColor"), caption: "09:00 AM")
                CaptionBullet(color: Color("YellowBulletColor"), caption: "09:30 AM")
                CaptionBullet(color: Color("RedBulletColor"), caption: "10:00 AM")
            }
        }
    }
}
