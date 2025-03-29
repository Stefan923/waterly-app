//
//  NotificationController.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 18.06.2023.
//

import WatchKit
import Foundation
import UserNotifications

class ExtensionDelegate: NSObject, WKApplicationDelegate, UNUserNotificationCenterDelegate {
    
    private var isNotificationActionActive: Bool = false
    private var notificationAction: ([AnyHashable : Any]) -> Void = {_ in }
    private var notificationData: [AnyHashable : Any]? = nil
    
    func applicationDidFinishLaunching() {
        WKExtension.shared().isAutorotating = true
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                WKExtension.shared().registerForRemoteNotifications()
            }
        }
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
    
}
