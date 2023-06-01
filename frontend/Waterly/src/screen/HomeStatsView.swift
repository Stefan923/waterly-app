//
//  HomeStatsView.swift
//  Waterly
//
//  Created by Stefan Popescu on 04.04.2023.
//

import SwiftUI

struct HomeStatsView: View {
    @StateObject private var router = Router()
    @EnvironmentObject var wcSessionManager: WCSessionManager
    
    private let handleSignOut: () -> Void
    
    init(handleSignOut: @escaping () -> Void) {
        self.handleSignOut = handleSignOut
    }
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
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
                                .frame(height: geometry.size.height * 0.735, alignment: .bottom)
                        }
                        
                        VStack(spacing: 0.0) {
                            HStack {
                                Spacer()
                                
                                IconButton(icon: Image("settings-white")) {
                                    router.push("SettingsView")
                                }.frame(width: 36, height: 36, alignment: .trailing)
                                    .padding([.trailing], 32)
                                    .padding([.top], 48)
                            }
                            .frame(alignment: .top)
                            .padding([.bottom], 12)
                            
                            RoundedProgressView(title: "Daily water consumption target", value: 0.33)
                                .padding([.horizontal], 32)
                                .padding([.bottom], 12)
                            
                            RoundedProgressView(title: "Daily calories consumption target", value: 0.44)
                                .padding([.horizontal], 32)
                            
                            Spacer(minLength: 0.0)
                        }
                        
                        VStack(spacing: 20.0) {
                            Spacer(minLength: 0.0)
                            
                            ScrollView(.vertical) {
                                let colors = [Color("RedBulletColor"), Color("GreenBulletColor"), Color("GreenBulletColor"), Color("GreenBulletColor"), Color("YellowBulletColor"), Color("GreenBulletColor"), Color("GreenBulletColor"), Color("RedBulletColor"), Color("GreenBulletColor")]
                                let captions = ["09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "12:30 PM"]
                                CaptionBulletPanel(title: "Drink liquids notification", colors: colors, captions: captions)
                                    .frame(width: 350.0, height: 220.0)
                                
                                Spacer(minLength: 15.0)
                                
                                CaptionBulletPanel(title: "Eat meal notification", colors: colors, captions: captions)
                                    .frame(width: 350.0, height: 120.0)
                                
                                Spacer(minLength: 15.0)
                                
                                VStack(spacing: 0.0) {
                                    if !wcSessionManager.receivedData.isEmpty {
                                        if let status = wcSessionManager.receivedData[0]["status"] as? NSObject {
                                            Text("Received Data: \(status)")
                                                .foregroundColor(Color("TextFieldFontColor"))
                                        } else {
                                            Text("Received Data: N/A")
                                                .foregroundColor(Color("TextFieldFontColor"))
                                        }
                                    }
                                    RoundedCornersButton(title: "Liquids consumption statistics", radius: 0.30, corners: [.top], buttonWidth: 350.0) {
                                        router.push("ConsumptionStatisticsView")
                                    }
                                    RoundedCornersButton(title: "Calories consumption statistics", radius: 0.30, corners: [], buttonWidth: 350.0) {
                                        router.push("ConsumptionStatisticsView")
                                    }
                                    RoundedCornersButton(title: "Uncertain gestures", radius: 0.30, corners: [.bottom], buttonWidth: 350.0) {
                                        router.push("UncertainGesturesView")
                                    }
                                }
                            }
                            .frame(height: geometry.size.height * 0.68, alignment: .bottom)
                        }
                    }
                    .frame(height: geometry.size.height * 1.05)
                }
            }
            .ignoresSafeArea(.all, edges: .all)
            .navigationDestination(for: String.self) { view in
                if (view == "SettingsView") {
                    SettingsView(handleSignOut: self.handleSignOut)
                } else if (view == "ConsumptionStatisticsView") {
                    ConsumptionStatisticsView()
                }
            }
        }
        .environmentObject(router)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(handleSignOut: {})
            .environmentObject(WCSessionManager.shared)
    }
}
