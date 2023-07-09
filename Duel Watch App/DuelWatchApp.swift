//
//  DuelApp.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 9/29/22.
//

import SwiftUI

@main
struct DuelWatchApp: App {
    // Create an instance of the ExtensionDelegate
    @StateObject private var wcDelegate = ExtensionDelegate.shared

    var body: some Scene {
        WindowGroup {
            // Provide InitialView with the ExtensionDelegate
            DuelView().environmentObject(wcDelegate)
        }
    }
}
