//
//  JoinRequestListView.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 7/9/23.
//

import SwiftUI

struct JoinRequestListView: View {
    @StateObject private var wcService = ExtensionDelegate.shared.watchConnectivityService
    @State private var joinRequest: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text(joinRequest ?? "No request")
                .font(.headline)
            HStack {
                Button(action: { self.respondToJoinRequest(accepted: true) }) {
                    Text("Accept")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: { self.respondToJoinRequest(accepted: false) }) {
                    Text("Decline")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onReceive(wcService.$message
            .map { message in
                message?["joinRequest"] as? String
            }
            .receive(on: DispatchQueue.main)) { joinRequest in
                self.joinRequest = joinRequest
            }
    }
    
    func respondToJoinRequest(accepted: Bool) {
        // Send a message back to the iPhone app with the response
        wcService.sendMessage(["response": accepted ? "accept" : "decline", "user": joinRequest ?? ""])
        // Clear the join request
        joinRequest = nil
    }
}
