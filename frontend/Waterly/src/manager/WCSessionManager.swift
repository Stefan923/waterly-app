//
//  WCSessionManager.swift
//  Waterly
//
//  Created by Stefan Popescu on 17.05.2023.
//

import WatchConnectivity
import Combine
import SwiftUI

final class WCSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WCSessionManager()

    private var session: WCSession?
    
    @Published var refresh: Bool = false
    
    @Published var receivedData: [[String: Any]] = []
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        return
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        if let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() {
            if let consumptionId = userInfo["id"] as? String,
               let consumptionStatus = userInfo["consumptionStatus"] as? String,
               let quantity = userInfo["quantity"] as? Float {
                if consumptionId == "new_entry" {
                    ConsumptionService().createConsumption(consumption: ConsumptionRequest(
                        userId, .LIQUID, ConsumptionStatus.parseValue(value: consumptionStatus), quantity
                    ), completion: { _ in
                        self.refresh.toggle()
                    })
                } else {
                    ConsumptionService().updateConsumption(consumption: ConsumptionUpdateRequest(
                        id: consumptionId,
                        consumptionStatus: ConsumptionStatus.parseValue(value: consumptionStatus),
                        quantity: quantity
                    ), completion: { _ in
                        self.refresh.toggle()
                    })
                }
            }
        } else {
            receivedData.append(userInfo)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let sensorData = message["sensorData"] as? String {
            ConsumptionService().saveSensorData(sensorData: sensorData, completion: { result in
                switch result {
                case .success(let message):
                    print(message)
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            })
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        if let requestType = message["requestType"] as? String {
            print("Received an watch request of type: \(requestType)")
            if requestType == "USER_SETTINGS" {
                if let userSettings = UserSettingsManager.shared.getUserSettings() {
                    replyHandler([
                        "gestureDetection": userSettings.gesturesDetection,
                        "developerMode": userSettings.developerMode,
                        "defaultLiquidsConsumption": userSettings.defaultLiquidsConsumption
                    ])
                }
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        return
    }

    func sessionDidDeactivate(_ session: WCSession) {
        return
    }
    
    func processReceivedData() -> Void {
        receivedData.forEach({ userInfo in
            if let consumptionId = userInfo["id"] as? String,
               let consumptionStatus = userInfo["consumptionStatus"] as? String,
               let quantity = userInfo["quantity"] as? Float,
               let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() {
                if consumptionId == "new_entry" {
                    ConsumptionService().createConsumption(consumption: ConsumptionRequest(
                        userId,
                        .LIQUID,
                        ConsumptionStatus.parseValue(value: consumptionStatus),
                        quantity
                    ), completion: { _ in
                        self.refresh.toggle()
                    })
                } else {
                    ConsumptionService().updateConsumption(consumption: ConsumptionUpdateRequest(
                        id: consumptionId,
                        consumptionStatus: ConsumptionStatus.parseValue(value: consumptionStatus),
                        quantity: quantity
                    ), completion: { _ in
                        self.refresh.toggle()
                    })
                }
            }
        })
        receivedData.removeAll()
    }
}
