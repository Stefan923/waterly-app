//
//  DataTransfer.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 16.05.2023.
//

import WatchConnectivity
import WatchKit

class DataTransferSender: NSObject {
    private var wcSessionManager = WCSessionManager.shared
    
    func sendToSmartphone(notificationId: String, consumption: Int, status: String) -> Bool {
        if WCSession.isSupported() {
            let session = WCSession.default
            
            if session.activationState == .activated {
                let dataToSend: [String: Any] = [
                    "id": notificationId,
                    "quantity": consumption,
                    "consumptionStatus": status
                ]
                
                print(dataToSend)
                
                session.transferUserInfo(dataToSend)
                return true
            } else {
                print("[DataTransferSender#sendToSmartphone()] WCSession is not active.")
                return false
            }
        } else {
            print("[DataTransferSender#sendToSmartphone()] WCSession is not supported on this device.")
            return false
        }
    }
    
    func sendSensorData(sensorData: String, fileName: String) -> Void {
        WCSession.default.sendMessage(["sensorData": sensorData], replyHandler: nil) { (error) in
            print("Error sending sensor data to iPhone: \(error)")
        }
    }
    
    func sendRequestToSmartphone(message: [String : Any], replyHandler: @escaping (([String : Any]) -> Void)) -> Void {
        WCSession.default.sendMessage(message, replyHandler: replyHandler) { (error) in
            print("Error sending request to iPhone: \(error)")
        }
    }
}
