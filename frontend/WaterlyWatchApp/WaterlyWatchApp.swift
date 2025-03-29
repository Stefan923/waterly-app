//
//  WaterlyWatchApp.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 18.11.2022.
//

import SwiftUI
import CoreMotion

@main
struct WaterlyWatchApp: App {
    @WKApplicationDelegateAdaptor(ExtensionDelegate.self) var appDelegate
    
    @State var showNotificationView: Bool = false
    @State var showDrinkActivityDetectedView: Bool = false
    @State var notificationData: [AnyHashable: Any] = [:]
    @State var recordButtonDisabled: Bool = false
    @State var gestureDetectionEnabled: Bool = false
    @State var developerMode: Bool = false
    @State var defaultLiquidsConsumption: Int = 0
    private let sensorDataRecorder = SensorDataRecorder()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showNotificationView {
                    if notificationData["consumptionType"] as! String == "LIQUID" {
                        DrinkNotificationView(notificationData: $notificationData, onFinish: self.onNotificationFinish)
                    } else {
                        MealNotificationView(notificationData: $notificationData, onFinish: self.onNotificationFinish)
                    }
                } else if showDrinkActivityDetectedView {
                    DrinkActivityDetectedView(defaultConsumption: defaultLiquidsConsumption, onFinish: self.onGestureFinish)
                } else {
                    VStack {
                        Text("No notification received.")
                            .padding(.bottom, 4)
                        
                        if gestureDetectionEnabled {
                            Button("Start Detection", action: {
                                recordButtonDisabled = true
                                sensorDataRecorder.startRecordingSensorData(onGestureDetection: self.onGestureDetection)
                            })
                            .disabled(recordButtonDisabled)
                        }
                        
                        if developerMode {
                            Button("Record Sensor", action: {
                                sensorDataRecorder.recordOneWindowOfSensorData()
                            })
                        }
                    }
                }
            }
            .onAppear(perform: {
                appDelegate.setNotificationAction(self.onNotificationReceive)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    DataTransferSender().sendRequestToSmartphone(message: ["requestType": "USER_SETTINGS"], replyHandler: { reply in
                        print("Received response from smartphone: \(reply)")
                        
                        if let response = reply["gestureDetection"] as? Bool {
                            DispatchQueue.main.async {
                                gestureDetectionEnabled = response
                            }
                        }
                        if let response = reply["developerMode"] as? Bool {
                            DispatchQueue.main.async {
                                developerMode = response
                            }
                        }
                        if let response = reply["defaultLiquidsConsumption"] as? Int {
                            DispatchQueue.main.async {
                                defaultLiquidsConsumption = response
                            }
                        }
                    })
                }
            })
        }
    }
    
    func onNotificationReceive(_ notificationData: [AnyHashable: Any]) -> Void {
        self.notificationData = notificationData
        self.showNotificationView = true
    }
    
    func onGestureFinish() -> Void {
        self.showDrinkActivityDetectedView = false
    }
    
    func onNotificationFinish() -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            exit(0)
        }
    }
    
    func onGestureDetection() -> Void {
        self.showDrinkActivityDetectedView = true
    }
}
