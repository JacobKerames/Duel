//
//  InitialView.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 9/29/22.
//

import SwiftUI
import WatchConnectivity

struct InitialView: View {
    @StateObject private var wcDelegate = ExtensionDelegate.shared
    
    var body: some View {
        VStack {
            Button(action: {
                wcDelegate.sendMessage(["action": "start"])
            }) {
                HStack {
                    Image(systemName: "hand.point.right.fill")
                    Text("Begin a Duel")
                }
            }
            
            Button(action: {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
