//
//  AppDelegate.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.06.2023.
//

import SwiftUI
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    private var isNotificationActionActive: Bool = false
    private var notificationAction: ([AnyHashable : Any]) -> Void = {_ in }
    private var notificationData: [AnyHashable : Any]? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerBackgroundTasks()
        scheduleAppRefresh()
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge, .list, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notificationData = response.notification.request.content.userInfo
        if self.isNotificationActionActive {
            notificationAction(notificationData)
        } else {
            self.notificationData = notificationData
        }
        
        completionHandler()
    }
    
    func setNotificationAction(_ notificationAction: @escaping ([AnyHashable : Any]) -> Void) -> Void {
        self.notificationAction = notificationAction
        self.isNotificationActionActive = true
        
        if notificationData != nil {
            self.notificationAction(notificationData!)
        }
    }
    
    private func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "me.stefan923.Waterly.update_notifications", using: nil) { task in
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
    }
    
    private func handleAppRefreshTask(task: BGAppRefreshTask) {
        task.expirationHandler = {}
        
        if let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() {
            ConsumptionService().getTodayConsumptionsByUserId(userId: userId, page: 0, size: 100, completion: { result in
                switch result {
                case .success(let consumptionsDto):
                    if let userSettings = UserSettingsManager.shared.getUserSettings() {
                        NotificationScheduler().sendNotificationsForConsumptions(consumptionsDto.consumptions, userSettings)
                    }
                    
                    break
                case .failure(_):
                    break
                }
            })
        }
        
        NotificationScheduler().sendNotification(5, "Fetched data from server", "Successfully fetched data from server.")
        task.setTaskCompleted(success: true)
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "me.stefan923.Waterly.update_notifications")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 30)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Unable to schedule app refresh: \(error.localizedDescription)")
        }
    }
}
