//
//  ExtensionDelegate.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 7/8/23.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    let wcController = WatchConnectivityController()
    
    func applicationDidFinishLaunching() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // handle session activation
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // handle incoming messages from iOS app
    }
}
