//
//  UncertainGesturesView.swift
//  Waterly
//
//  Created by Stefan Popescu on 04.05.2023.
//

import SwiftUI

struct UncertainGesturesView : View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var router: Router
    
    private var settings: [String] = ["April 26th 2023 - 11:30 AM", "April 28th 2023 - 08:30 AM", "May 2nd 2023 - 02:30 PM"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("PrimaryColor")
                    .ignoresSafeArea(.all, edges: .all)
                
                ZStack {
                    VStack {
                        Spacer()
                        
                        WaveEdgedRectangle()
                            .fill(Color("SecondaryColor"))
                            .shadow(color: .black.opacity(0.25), radius: 15, x: 0, y: -10)
                            .frame(height: geometry.size.height * 0.98, alignment: .bottom)
                    }
                    .frame(height: geometry.size.height * 1.05)
                    
                    VStack {
                        HStack {
                            Text("Uncertain gestures")
                                .foregroundColor(Color("TextFieldFontColor"))
                                .font(.system(size: 20).weight(.bold))
                                .padding([.bottom], 9.0)
                                .frame(alignment: .leading)
                            
                            Spacer()
                        }
                        .padding([.horizontal], geometry.size.width * 0.10)
                        
                        ZStack {
                            RoundedCornersRectangle(radius: 0.02, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                                .fill(Color("RectangleFillColor"),
                                      strokeBorder: Color("RectangleEdgeColor"),
                                      lineWidth: 1.0)
                                .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.80)
                            
                            VStack(spacing: 0.0) {
                                ForEach(settings, id: \.self) { settingTitle in
                                    if (settingTitle == settings.first) {
                                        if (settingTitle == settings.last) {
                                            DropdownButton(title: settingTitle,
                                                           radius: 0.20,
                                                           corners: [.all],
                                                           expandedCorners: [.all],
                                                           buttonWidth: geometry.size.width * 0.80) {
                                                IncrementalInput(value: 0)
                                            }
                                            .frame(alignment: .top)
                                        } else {
                                            DropdownButton(title: settingTitle,
                                                           radius: 0.20,
                                                           corners: [.top],
                                                           expandedCorners: [.top],
                                                           buttonWidth: geometry.size.width * 0.80) {
                                                IncrementalInput(value: 0)
                                            }
                                            .frame(alignment: .top)
                                        }
                                    } else if (settingTitle == settings.last) {
                                        DropdownButton(title: settingTitle,
                                                       radius: 0.20,
                                                       corners: [.bottom],
                                                       expandedCorners: [.bottom],
                                                       buttonWidth: geometry.size.width * 0.80) {
                                            IncrementalInput(value: 0)
                                        }
                                        .frame(alignment: .top)
                                    } else {
                                        DropdownButton(title: settingTitle,
                                                       radius: 0.20,
                                                       corners: [],
                                                       expandedCorners: [],
                                                       buttonWidth: geometry.size.width * 0.80) {
                                            IncrementalInput(value: 0)
                                        }
                                        .frame(alignment: .top)
                                    }
                                    
                                }
                                
                                Spacer(minLength: 0.0)
                            }
                            .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.80)
                        }
                    }
                    .padding([.top], geometry.size.height * 0.06)
                }
            }
        }
    }
}

struct UncertainGesturesView_Previews: PreviewProvider {
    static var previews: some View {
        UncertainGesturesView()
    }
}
