//
//  ExtensionDelegate.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 7/8/23.
//

import WatchKit
import WatchConnectivity
import Combine

// The main class in the WatchKit extension that acts as a delegate for app-level behaviors, like life cycle.
class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, ObservableObject {
    // Create a shared instance of the ExtensionDelegate which can be accessed from anywhere in the code
    static let shared = ExtensionDelegate()
    
    @Published var message: [String: Any]?

    private override init() {
        super.init()
        // Check if the current device supports watch connectivity
        if WCSession.isSupported() {
            let session  = WCSession.default // Get the default session and set its delegate
            session.delegate = self
            session.activate() // Activate the session to start communicating with the paired iPhone
        }
    }
    
    // Activation of the session has completed
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Log activation state and any error
        print("WCSession activation completed. State: \(activationState.rawValue)")
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        }
    }

    // Receive a message from the iPhone app
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Update published `message` property with received message
        DispatchQueue.main.async {
            self.message = message
        }
    }

    // Send a message from the Watch app to the iPhone app
    func sendMessage(_ message: [String: Any]) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                // Handle the error here
                print("Failed to send message: \(error)")
            }
        }
    }
}
