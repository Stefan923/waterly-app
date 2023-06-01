//
//  WCSessionManager.swift
//  Waterly
//
//  Created by Stefan Popescu on 17.05.2023.
//

import WatchConnectivity
import Combine

final class WCSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WCSessionManager()

    private var session: WCSession?
    
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
        receivedData.append(userInfo)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        return
    }

    func sessionDidDeactivate(_ session: WCSession) {
        return
    }
}
