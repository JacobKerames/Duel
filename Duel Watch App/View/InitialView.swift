//
//  InitialView.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 9/29/22.
//
import SwiftUI
import MultipeerConnectivity

struct InitialView: View {
    @StateObject private var multipeer = Multipeer()

    var body: some View {
        VStack {
            Button(action: {
                self.multipeer.startHosting()
            }) {
                HStack {
                    Image(systemName: "hand.point.right.fill")
                    Text("Begin a Duel")
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
