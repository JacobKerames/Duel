//
//  SettingsView.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 10/11/22.
//

import SwiftUI

struct SettingsView: View {
    //Username
    @State var username: String = UserDefaults.standard.string(forKey: "Username") ?? "Enter Username"
    @State var usernameText: String = ""
    //Wrist Orientation
    @State var orientation: String = UserDefaults.standard.string(forKey: "Wrist Orientation") ?? ""
    @State private var selectedOrientation = 0
    private var orientations = ["Left", "Right"]
    
    //Create user defaults
    let userDefaults = UserDefaults.standard
    
    var body: some View {
        NavigationView {
            Form {
                //Username field
                Section(header: Text("Username:")) {
                    TextField(username, text: $usernameText)
                        .onSubmit {
                            UserDefaults.standard.set(usernameText, forKey: "Username")
                            username = usernameText
                        }
                }
                //Wrist Orientation picker
                Picker(selection: $selectedOrientation, label: Text("Change Wrist")) {
                    ForEach(0 ..< orientations.count, id: \.self) {
                        Text(self.orientations[$0])
                    }
                }
                //Update default user setting for wrist orientation
                .onChange(of: selectedOrientation) { tag in
                    UserDefaults.standard.set(orientations[selectedOrientation], forKey: "Wrist Orientation");
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
