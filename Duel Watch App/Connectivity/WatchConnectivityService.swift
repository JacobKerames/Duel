//
//  WatchConnectivityService.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 7/9/23.
//

import WatchConnectivity

class WatchConnectivityService: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchConnectivityService()

    @Published var message: [String: Any]?

    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation completion if needed
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        self.message = message
    }

    func sendMessage(_ message: [String: Any]) {
        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
}
