//
//  WatchConnectivityController.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 7/8/23.
//

import WatchConnectivity

class WatchConnectivityController: NSObject, WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        <#code#>
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        <#code#>
    }
    
    static let shared = WatchConnectivityController()
    var didReceiveMessage: (([String: Any]) -> Void)?
    
    public override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation completion
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Call the didReceiveMessage closure
        didReceiveMessage?(message)
    }
    
    func sendMessage(_ message: [String: Any]) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }
    }
}
