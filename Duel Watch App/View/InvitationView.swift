//
//  InvitationView.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 7/9/23.
//

import SwiftUI

struct InvitationView: View {
    @StateObject private var wcService = ExtensionDelegate.shared.watchConnectivityService
    @State private var showInvitation = false
    @State private var invitationFrom = ""

    var body: some View {
        // Your existing view code here...

        // Whenever a new message is received, check if it's an invitation
        .onChange(of: wcService.message, perform: { message in
            if let invitation = message?["invitation"] as? String {
                self.invitationFrom = invitation
                self.showInvitation = true
            }
        })
        // Show an alert when an invitation is received
        .alert(isPresented: $showInvitation) {
            Alert(
                title: Text("New invitation"),
                message: Text("You have received an invitation to join a game from \(self.invitationFrom)."),
                primaryButton: .default(Text("Accept")) {
                    self.acceptInvitation()
                },
                secondaryButton: .cancel(Text("Decline")) {
                    self.declineInvitation()
                }
            )
        }
    }

    func acceptInvitation() {
        // Send a message back to the iPhone app accepting the invitation
        wcService.sendMessage(["invitationResponse": "accept"])
        // You might also want to navigate to a new view here, or update some other part of your UI
    }

    func declineInvitation() {
        // Send a message back to the iPhone app declining the invitation
        wcService.sendMessage(["invitationResponse": "decline"])
    }
}
