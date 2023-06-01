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
                    "notificationId": notificationId,
                    "consumption": consumption,
                    "status": status
                ]
                
                session.transferUserInfo(dataToSend)
                return true
            } else {
                return false
                print("[DataTransferSender#sendToSmartphone()] WCSession is not active.")
            }
        } else {
            return false
            print("[DataTransferSender#sendToSmartphone()] WCSession is not supported on this device.")
        }
    }
}
