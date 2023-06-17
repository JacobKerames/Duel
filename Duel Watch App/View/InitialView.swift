//
//  InitialView.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 9/29/22.
//

import SwiftUI

struct InitialView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Duel")
                //List for scrolling
                List {
                    //Duel button
                    NavigationLink(destination: DuelView(), label: {
                        HStack {
                            Image(systemName: "hand.point.right.fill")
                            Text("Begin a Duel")
                        }
                        .padding()
                    })
                    //Settings button
                    NavigationLink(destination: SettingsView(), label: {
                        HStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .padding()
                    })
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
