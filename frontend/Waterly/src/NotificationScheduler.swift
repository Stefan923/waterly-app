//
//  NotificationScheduler.swift
//  Waterly
//
//  Created by Stefan Popescu on 10.05.2023.
//

import UserNotifications

class NotificationScheduler {
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("User granted permission: \(granted)")
            }
        }
    }
    
    func sendNotificationsForConsumptions(_ consumptions: [Consumption], _ userSettings: UserSettings) {
        self.clearScheduledNotifications();
        
        consumptions.forEach({ consumption in
            if consumption.consumptionStatus == .NO_ENTRY {
                let timeInterval = calculateTimeIntervalToTime(date: consumption.createdAt)
                if timeInterval > 0 {
                    self.sendNotification(consumption, userSettings, timeInterval)
                }
            }
        })
    }
    
    func sendNotification(_ consumption: Consumption, _ userSettings: UserSettings, _ timeInterval: Double) {
        var title: String
        var subtitle: String
        var notificationData: [String: Any] = [:]
        if consumption.consumptionType == .LIQUID {
            title = "Stay hydrated!"
            subtitle = "It's time to have a refreshing glass of water. Stay hydrated and keep up the good work!"
            notificationData = [
                "id": consumption.id,
                "consumptionType": consumption.consumptionType.toString(),
                "defaultLiquidsConsumption": userSettings.defaultLiquidsConsumption
            ]
        } else {
            title = "Foodie time!"
            subtitle = "Give yourself a break and enjoy a satisfying meal. Take a moment to refuel and recharge!"
            notificationData = [
                "id": consumption.id,
                "consumptionType": consumption.consumptionType.toString(),
                "defaultCaloriesConsumption": userSettings.defaultCaloriesConsumption
            ]
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        content.userInfo = notificationData
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled!")
            }
        }
    }
    
    func sendNotification(_ timeInterval: Double, _ title: String, _ subtitle: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled!")
            }
        }
    }
    
    func clearScheduledNotifications() {
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests { notificationRequests in
            let identifiers = notificationRequests.map { $0.identifier }
            center.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    func calculateTimeIntervalToTime(date: Date) -> Double {
        let calendar = Calendar.current
        let currentDate = Date()
        
        if calendar.compare(date, to: currentDate, toGranularity: .minute) == .orderedDescending {
            return Double(calendar.dateComponents([.second], from: currentDate, to: date).second ?? -1)
        }
        
        return -1
    }
}
