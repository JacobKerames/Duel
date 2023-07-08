//
//  WatchConnectivityController.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 7/8/23.
//

import WatchConnectivity

class WatchConnectivityController {
    var session = WCSession.default
    
    func sendMessage(_ message: [String: Any]) {
        session.sendMessage(message, replyHandler: nil)
    }
}
