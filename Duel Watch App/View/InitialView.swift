//
//  InitialView.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 9/29/22.
//

import SwiftUI
import WatchConnectivity

// Main user interface for the Watch app
struct InitialView: View {
    // Use a StateObject to create a persistent, application-wide instance of the WatchConnectivity delegate. This will handle sending and receiving messages between the watch and the paired iPhone.
    @StateObject private var wcDelegate = ExtensionDelegate.shared
    
    var body: some View {
        VStack {
            // A button that sends a "start" action to the paired iPhone when pressed.
            Button(action: {
                // Received by the WatchConnectivityController in the iPhone app and passed on to the MultipeerController.
                wcDelegate.sendMessage(["action": "start"])
            }) {
                HStack {
                    Image(systemName: "hand.point.right.fill")
                    Text("Begin a Duel")
                }
            }
            
            // A button that sends a "connect" action to the paired iPhone when pressed.
            Button(action: {
                // Received by the WatchConnectivityController and passed on to the MultipeerController.
                wcDelegate.sendMessage(["action": "connect"])
            }) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Join a Duel")
                }
            }
        }
    }
}

// Preview of the InitialView for use in the SwiftUI canvas.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
