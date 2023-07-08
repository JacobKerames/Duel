//
//  AppDelegate.swift
//  Duel iOS App
//
//  Created by Jacob Kerames on 7/8/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    // Create instances of the MultipeerController and WatchConnectivityController
    let multipeerController = MultipeerController()
    let wcController = WatchConnectivityController.shared

    // This method is called after the app has been launched.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Start hosting a multipeer connectivity session
        multipeerController.startHosting()
        
        // Listen for updates from WatchConnectivityController and forward them to MultipeerController
        wcController.didReceiveMessage = { [weak self] message in
            // Check if the received message has an "action" key
            if let action = message["action"] as? String {
                // Depending on the value of the "action" key, call a method on the MultipeerController
                switch action {
                case "start":
                    // Start hosting a new multipeer connectivity session
                    self?.multipeerController.startHosting()
                case "connect":
                    // Start looking for other multipeer connectivity sessions to join
                    self?.multipeerController.startJoining()
                default:
                    break
                }
            }
        }
        
        return true
    }
    
    // ...
}
