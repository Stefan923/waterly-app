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
    
    var userSettingsService = UserSettingsService()
    
    @State private var defaultLiquidsConsumption: Int
    @State private var defaultCaloriesConsumption: Int
    @State private var dailyLiquidsConsumptionTarget: Int
    @State private var dailyCaloriesConsumptionTarget: Int
    @State private var dailyLiquidsConsumptions: Int
    @State private var dailyCaloriesConsumptions: Int
    @State private var gesturesDetection: Bool
    @State private var developerMode: Bool
    
    @State private var errorAlert: ErrorAlert?
    
    init(handleSignOut: @escaping () -> Void) {
        self.handleSignOut = handleSignOut
        
        let userSettings = UserSettingsManager.shared.getUserSettings()
        _defaultLiquidsConsumption = State(initialValue: userSettings?.defaultLiquidsConsumption ?? 0)
        _defaultCaloriesConsumption = State(initialValue: userSettings?.defaultCaloriesConsumption ?? 0)
        _dailyLiquidsConsumptionTarget = State(initialValue: userSettings?.dailyLiquidsConsumptionTarget ?? 0)
        _dailyCaloriesConsumptionTarget = State(initialValue: userSettings?.dailyCaloriesConsumptionTarget ?? 0)
        _dailyLiquidsConsumptions = State(initialValue: userSettings?.dailyLiquidsConsumptions ?? 0)
        _dailyCaloriesConsumptions = State(initialValue: userSettings?.dailyCaloriesConsumptions ?? 0)
        _gesturesDetection = State(initialValue: userSettings?.gesturesDetection ?? true)
        _developerMode = State(initialValue: userSettings?.developerMode ?? false)
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
                                .fill(.white.shadow(.drop(radius: 2)))
                                .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.80)
                            
                            ScrollView(.vertical) {
                                VStack(spacing: 0.0) {
                                    DropdownButton(title: "Default liquids consumption",
                                                   radius: 0.20,
                                                   corners: [.top],
                                                   expandedCorners: [.top],
                                                   buttonWidth: geometry.size.width * 0.80) {
                                        IncrementalInput(value: $defaultLiquidsConsumption, measureUnit: "ml", incrementStep: 25, minValue: 0, maxValue: 2000)
                                    }.frame(alignment: .top)
                                    
                                    DropdownButton(title: "Default calories consumption",
                                                   radius: 0.20,
                                                   corners: [],
                                                   expandedCorners: [],
                                                   buttonWidth: geometry.size.width * 0.80) {
                                        IncrementalInput(value: $defaultCaloriesConsumption, measureUnit: "cal", incrementStep: 25, minValue: 0, maxValue: 2000)
                                    }.frame(alignment: .top)
                                    
                                    DropdownButton(title: "Daily liquids target",
                                                   radius: 0.20,
                                                   corners: [],
                                                   expandedCorners: [],
                                                   buttonWidth: geometry.size.width * 0.80) {
                                        IncrementalInput(value: $dailyLiquidsConsumptionTarget, measureUnit: "ml", incrementStep: 100, minValue: 0, maxValue: 10000)
                                    }.frame(alignment: .top)
                                    
                                    DropdownButton(title: "Daily calories target",
                                                   radius: 0.20,
                                                   corners: [],
                                                   expandedCorners: [],
                                                   buttonWidth: geometry.size.width * 0.80) {
                                        IncrementalInput(value: $dailyCaloriesConsumptionTarget, measureUnit: "cal", incrementStep: 100, minValue: 0, maxValue: 10000)
                                    }.frame(alignment: .top)
                                    
                                    DropdownButton(title: "Daily liquid notifications",
                                                   radius: 0.20,
                                                   corners: [],
                                                   expandedCorners: [],
                                                   buttonWidth: geometry.size.width * 0.80) {
                                        IncrementalInput(value: $dailyLiquidsConsumptions, measureUnit: "notifications", incrementStep: 1, minValue: 5, maxValue: 40)
                                    }.frame(alignment: .top)
                                    
                                    DropdownButton(title: "Daily calories notifications",
                                                   radius: 0.20,
                                                   corners: [],
                                                   expandedCorners: [],
                                                   buttonWidth: geometry.size.width * 0.80) {
                                        IncrementalInput(value: $dailyCaloriesConsumptions, measureUnit: (dailyCaloriesConsumptions == 1 ? "notification" : "notifications"), incrementStep: 1, minValue: 1, maxValue: 6)
                                    }.frame(alignment: .top)
                                    
                                    RoundedCornersButton(title: "Notifications schedule",
                                                         radius: 0.20,
                                                         corners: [],
                                                         buttonWidth: geometry.size.width * 0.80) {
                                        router.push("ScheduleSettingsView")
                                    }
                                    
                                    DropdownButton(title: "Gestures detection",
                                                   radius: 0.20,
                                                   corners: [],
                                                   expandedCorners: [],
                                                   buttonWidth: geometry.size.width * 0.80) {
                                        ToggleInput(value: $gesturesDetection, title: "Enable gestures detection")
                                    }.frame(alignment: .top)
                                    
                                    DropdownButton(title: "Developer mode",
                                                   radius: 0.20,
                                                   corners: [],
                                                   expandedCorners: [],
                                                   buttonWidth: geometry.size.width * 0.80) {
                                        ToggleInput(value: $developerMode, title: "Enable developer mode")
                                    }.frame(alignment: .top)
                                    
                                    RoundedCornersButton(title: "Sign out", titleColor: .red, centerTitle: true, radius: 0.20, corners: [.bottom], buttonWidth: geometry.size.width * 0.80, displayIcon: false) {
                                        self.handleSignOut()
                                    }
                                }
                            }
                            .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.80)
                            .cornerRadius(14)
                        }
                    }
                    .padding([.top], geometry.size.height * 0.06)
                }
            }
        }
        .onDisappear(perform: {
            self.saveSettings()
        })
        .alert(item: $errorAlert) { error in
            Alert(title: Text(error.title), message: Text(error.message), dismissButton: .default(Text("Close")))
        }
    }
    
    private func saveSettings() -> Void {
        let userSettings = UserSettingsManager.shared.getUserSettings()
        
        if let userSettings = userSettings {
            userSettings.defaultLiquidsConsumption = self.defaultLiquidsConsumption
            userSettings.defaultCaloriesConsumption = self.defaultCaloriesConsumption
            userSettings.dailyLiquidsConsumptionTarget = self.dailyLiquidsConsumptionTarget
            userSettings.dailyCaloriesConsumptionTarget = self.dailyCaloriesConsumptionTarget
            userSettings.dailyLiquidsConsumptions = self.dailyLiquidsConsumptions
            userSettings.dailyCaloriesConsumptions = self.dailyCaloriesConsumptions
            userSettings.gesturesDetection = self.gesturesDetection
            userSettings.developerMode = self.developerMode
            
            UserSettingsManager.shared.setUserSettings(userSettings)
            self.userSettingsService.updateUserSettings(userSettings: userSettings, completion: { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    self.errorAlert = ErrorAlert(title: "Error", message: "\(error)")
                }
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(handleSignOut: {})
    }
}
