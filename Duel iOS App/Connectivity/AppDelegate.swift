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
    
    let multipeerController = MultipeerController()
    let wcController = WatchConnectivityController.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        multipeerController.startHosting()
        
        // Listen for updates from WatchConnectivityController and forward them to MultipeerController
        wcController.didReceiveMessage = { [weak self] message in
            if let action = message["action"] as? String {
                switch action {
                case "start":
                    self?.multipeerController.startHosting()
                case "connect":
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
