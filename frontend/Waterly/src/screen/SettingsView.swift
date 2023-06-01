//
//  SettingsView.swift
//  Waterly
//
//  Created by Stefan Popescu on 04.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: Router
    
    private let handleSignOut: () -> Void
    
    private var settings: [String] = ["Default water consumption", "Default calories consumption"]
    
    init(handleSignOut: @escaping () -> Void) {
        self.handleSignOut = handleSignOut
    }
    
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
                            Text("Settings")
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
                                        DropdownButton(title: settingTitle,
                                                       radius: 0.20,
                                                       corners: [.top],
                                                       expandedCorners: [.top],
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
                                
                                RoundedCornersButton(title: "Sign out", titleColor: .red, centerTitle: true, radius: 0.30, corners: [.bottom], buttonWidth: geometry.size.width * 0.80, displayIcon: false) {
                                    self.handleSignOut()
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(handleSignOut: {})
    }
}
