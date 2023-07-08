//
//  AppDelegate.swift
//  Duel iOS App
//
//  Created by Jacob Kerames on 7/8/23.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    var window: UIWindow?
    
    let wcController = WatchConnectivityController()
    let mpController = MultipeerController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        return true
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // handle session activation
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let action = message["action"] as? String {
            switch action {
            case "start":
                mpController.startHosting()
            case "connect":
                mpController.joinSession()
            default:
                break
            }
        }
    }
}
