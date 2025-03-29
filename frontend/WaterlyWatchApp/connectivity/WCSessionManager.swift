//
//  WCSessionManager.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 17.05.2023.
//

import WatchConnectivity
import Combine

final class WCSessionManager: NSObject, WCSessionDelegate {
    
    static let shared = WCSessionManager()

    private var session: WCSession?
    
    private override init() {
        super.init()
        
        print("WCS on")
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        return
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        return
    }
}
