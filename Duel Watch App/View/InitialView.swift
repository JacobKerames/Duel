//
//  InitialView.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 9/29/22.
//

import SwiftUI

struct InitialView: View {
    @StateObject private var viewModel = DuelView()

    var body: some View {
        VStack {
            // Only show the buttons if the duel hasn't started yet.
            if !viewModel.isDuelStarted {
                Button(action: {
                    viewModel.startDuel()
                }) {
                    HStack {
                        Image(systemName: "hand.point.right.fill")
                        Text("Begin a Duel")
                    }
                }

                Button(action: {
                    viewModel.joinDuel()
                }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Join a Duel")
                    }
                }
            }

            if viewModel.isCountingDown {
                Text("Countdown: \(viewModel.countdown)")
            } else if viewModel.countdown == 0 && viewModel.isDuelStarted {
                Text("DRAW!")
            } else {
                Text(viewModel.duelResult)
            }
        }
        .onReceive(viewModel.countdownTimer) { _ in
            viewModel.countdownTick()
        }
        .onChange(of: viewModel.isDrawDetected) { drawDetected in
            if drawDetected {
                viewModel.drawDetected()
            }
        }
    }
}
