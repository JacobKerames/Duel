//
//  WatchConnectivityController.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 7/8/23.
//

import WatchConnectivity

// Manages communication between iPhone app and its paired Apple Watch app.
class WatchConnectivityController: NSObject, WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session inactivation
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Handle session deactivation
    }
    
    // Singleton pattern allows the shared instance of WatchConnectivityController to be accessed from anywhere in the code
    static let shared = WatchConnectivityController()
    
    // A closure that is called whenever a message is received. Takes the received message as its parameter.
    var didReceiveMessage: (([String: Any]) -> Void)?
    
    public override init() {
        super.init()
        // Check if the current device supports watch connectivity
        if WCSession.isSupported() {
            // Get the default session and set its delegate
            let session = WCSession.default
            session.delegate = self
            session.activate() // Activate the session to start communicating with the paired Apple Watch
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation completion
    }
    
    // Check that the sent message was received
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Call the didReceiveMessage closure
        didReceiveMessage?(message)
    }
    
    // Send a message from the iPhone app to the Apple Watch app
    func sendMessage(_ message: [String: Any]) {
        // Check if the Apple Watch is reachable
        if WCSession.default.isReachable {
            // Send the message to the Apple Watch
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }
    }
}
