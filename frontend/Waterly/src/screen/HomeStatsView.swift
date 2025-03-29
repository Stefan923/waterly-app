//
//  HomeStatsView.swift
//  Waterly
//
//  Created by Stefan Popescu on 04.04.2023.
//

import SwiftUI

struct HomeStatsView: View {
    @StateObject private var router = Router()
    
    private let handleSignOut: () -> Void
    
    @ObservedObject private var wcSessionManager = WCSessionManager.shared
    
    @State private var drinkConsumptionInfo: [ConsumptionInfo] = []
    @State private var mealConsumptionInfo: [ConsumptionInfo] = []
    
    @State private var userSettings: UserSettings? = nil
    @State private var developerMode: Bool = false
    
    @State private var liquidsConsumptionProgress: CGFloat = 0
    @State private var caloriesConsumptionProgress: CGFloat = 0
    
    @State private var selectedConsumption: Consumption? = nil
    
    private var consumptionService = ConsumptionService()
    
    @State private var errorAlert: ErrorAlert?
    
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
                                    .padding([.trailing], 38)
                                    .padding([.top], 48)
                            }
                            .frame(alignment: .top)
                            .padding([.bottom], 12)
                            
                            RoundedProgressView(title: "Daily hydration tracking", value: liquidsConsumptionProgress)
                                .padding([.horizontal], 38)
                                .padding([.bottom], 12)
                            
                            RoundedProgressView(title: "Daily calories tracking", value: caloriesConsumptionProgress)
                                .padding([.horizontal], 38)
                            
                            Spacer(minLength: 0.0)
                        }
                        
                        VStack(spacing: 20.0) {
                            Spacer(minLength: 0.0)
                            
                            ScrollView(.vertical) {
                                VStack {
                                    CaptionBulletPanel(title: "Hydration Reminders", consumptions: $drinkConsumptionInfo)
                                        .frame(width: 350.0, height: 220.0)
                                        .padding(1)
                                    
                                    Spacer(minLength: 15.0)
                                    
                                    CaptionBulletPanel(title: "Meal Reminders", consumptions: $mealConsumptionInfo)
                                        .frame(width: 350.0, height: 120.0)
                                        .padding(1)
                                    
                                    Spacer(minLength: 15.0)
                                    
                                    VStack(spacing: 0.0) {
                                        RoundedCornersButton(title: "Hydration Stats", radius: 0.30, corners: [.top], buttonWidth: 350.0) {
                                            router.push("LiquidsConsumptionStatisticsView")
                                        }
                                        RoundedCornersButton(title: "Calorie Stats", radius: 0.30, corners: [], buttonWidth: 350.0) {
                                            router.push("CaloriesConsumptionStatisticsView")
                                        }
                                        RoundedCornersButton(title: "Add Consumption", radius: 0.30, corners: [], buttonWidth: 350.0) {
                                            router.push("AddConsumptionView")
                                        }
                                        RoundedCornersButton(title: "Delayed Notifications", radius: 0.30, corners: [], buttonWidth: 350.0) {
                                            router.push("PostphonedNotificationsView")
                                        }
                                        if self.developerMode {
                                            Menu {
                                                Button("Drink Notification", action: {
                                                    self.createConsumption(consumptionType: .LIQUID)
                                                })
                                                Button("Meal Notification", action: {
                                                    self.createConsumption(consumptionType: .FOOD)
                                                })
                                            } label: {
                                                RoundedCornersButton(title: "Trigger Notification", radius: 0.30, corners: [], buttonWidth: 350.0) {
                                                }
                                            }
                                        }
                                        RoundedCornersButton(title: "Your Profile", radius: 0.30, corners: [.bottom], buttonWidth: 350.0) {
                                            router.push("UserProfileView")
                                        }
                                    }
                                }
                                .padding(6)
                            }
                            .frame(height: geometry.size.height * 0.615, alignment: .bottom)
                            .padding(.bottom, 68)
                        }
                    }
                    .frame(height: geometry.size.height * 1.05)
                }
            }
            .ignoresSafeArea(.all, edges: .all)
            .navigationDestination(for: String.self) { view in
                if (view == "SettingsView") {
                    SettingsView(handleSignOut: self.handleSignOut)
                } else if (view == "ScheduleSettingsView") {
                    ScheduleSettingsView()
                } else if (view == "LiquidsConsumptionStatisticsView") {
                    ConsumptionStatisticsView(consumptionType: .LIQUID)
                } else if (view == "CaloriesConsumptionStatisticsView") {
                    ConsumptionStatisticsView(consumptionType: .FOOD)
                } else if (view == "AddConsumptionView") {
                    AddConsumptionView()
                } else if (view == "PostphonedNotificationsView") {
                    PostphonedNotificationsView(selectedConsumption: $selectedConsumption)
                } else if (view == "PostphonedNotificationView") {
                    PostphonedNotificationView(consumption: selectedConsumption)
                } else if (view == "UserProfileView") {
                    UserProfileView()
                } else if (view == "EditUserProfileView") {
                    EditUserProfileView()
                }
            }
            .onAppear(perform: {
                self.userSettings = UserSettingsManager.shared.getUserSettings()
                if let userSettings = self.userSettings {
                    developerMode = userSettings.developerMode
                }
                loadTodayConsumptions()
            })
            .onChange(of: wcSessionManager.refresh, perform: { _ in
                loadTodayConsumptions()
            })
            .alert(item: $errorAlert) { error in
                Alert(title: Text(error.title), message: Text(error.message), dismissButton: .default(Text("Close")))
            }
        }
        .environmentObject(router)
    }
    
    private func loadTodayConsumptions(_ resetNotifications: Bool = true) -> Void {
        if let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() {
            self.consumptionService.getTodayConsumptionsByUserId(userId: userId, page: 0, size: 100, completion: { result in
                switch result {
                case .success(let consumptionsDto):
                    drinkConsumptionInfo.removeAll()
                    mealConsumptionInfo.removeAll()
                    
                    consumptionsDto.consumptions.forEach { consumption in
                        if consumption.consumptionType == .LIQUID {
                            drinkConsumptionInfo.append(
                                ConsumptionInfo(consumption.id,
                                                convertConsumptionStatusToColor(consumptionStatus: consumption.consumptionStatus),
                                                convertDateToCaption(date: consumption.createdAt)))
                        } else {
                            mealConsumptionInfo.append(
                                ConsumptionInfo(consumption.id,
                                                convertConsumptionStatusToColor(consumptionStatus: consumption.consumptionStatus),
                                                convertDateToCaption(date: consumption.createdAt)))
                        }
                    }
                    if let userSettings = UserSettingsManager.shared.getUserSettings() {
                        self.computeDailyProgress(consumptionsDto.consumptions, userSettings)
                        if resetNotifications {
                            NotificationScheduler().sendNotificationsForConsumptions(consumptionsDto.consumptions, userSettings)
                        }
                    }
                    
                    break
                case .failure(let error):
                    self.errorAlert = ErrorAlert(title: "Error", message: "\(error)")
                    break
                }
            })
        }
    }
    
    private func convertConsumptionStatusToColor(consumptionStatus: ConsumptionStatus) -> Color {
        switch consumptionStatus {
        case .DONE:
            return Color("GreenBulletColor")
        case .POSTPHONED:
            return Color("YellowBulletColor")
        case .CANCELED:
            return Color("RedBulletColor")
        case .NO_ENTRY:
            return Color("GrayBulletColor")
        }
    }
    
    private func convertDateToCaption(date: Date) -> String {
        var suffix = "AM"
        
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        if hour >= 12 {
            suffix = "PM"
            hour -= 12
        }
        
        if hour == 0 {
            hour = 12
        }
        
        var stringHour = "\(hour)"
        var stringMinute = "\(minute)"
        if hour < 10 {
            stringHour = "0\(hour)"
        }
        if minute < 10 {
            stringMinute = "0\(minute)"
        }
        
        return "\(stringHour):\(stringMinute) \(suffix)"
    }
    
    private func createConsumption(consumptionType: ConsumptionType) {
        if let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() {
            let consumption = ConsumptionRequest(userId, consumptionType, .NO_ENTRY, 0)
            consumptionService.createConsumption(consumption: consumption, completion: { result in
                switch result {
                case .success(let createdConsumption):
                    if let userSettings = UserSettingsManager.shared.getUserSettings() {
                        NotificationScheduler().sendNotification(createdConsumption, userSettings, 5)
                        self.errorAlert = ErrorAlert(title: "Success",
                                                     message: "A notification will be received in 5 seconds.")
                        self.loadTodayConsumptions(false)
                    }
                    break
                case .failure(let error):
                    self.errorAlert = ErrorAlert(title: "Error", message: "\(error)")
                    break
                }
            })
        }
    }
    
    private func computeDailyProgress(_ consumptions: [Consumption], _ userSettings: UserSettings) {
        self.liquidsConsumptionProgress = CGFloat(computeProgressPercentage(consumptions
            .filter { $0.consumptionType == .LIQUID }
            .reduce(0.0) { $0 + $1.quantity }, Float(userSettings.dailyLiquidsConsumptionTarget)))
        self.caloriesConsumptionProgress = CGFloat(computeProgressPercentage(consumptions
            .filter { $0.consumptionType == .FOOD }
            .reduce(0.0) { $0 + $1.quantity }, Float(userSettings.dailyCaloriesConsumptionTarget)))
    }
    
    private func computeProgressPercentage(_ actual: Float, _ target: Float) -> Float {
        return min((actual / target), 1.0)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(handleSignOut: {})
            .environmentObject(WCSessionManager.shared)
    }
}
