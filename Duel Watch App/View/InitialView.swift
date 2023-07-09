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
    @StateObject private var wcDelegate = ExtensionDelegate.shared
    @StateObject private var motionManager = MotionManager()

    @State private var duelResult: String = ""
    @State private var countdown = 3
    @State private var isCountingDown = false
    @State private var didDrawEarly = false
    @State private var isDuelStarted = false
    @State private var isDrawDetected = false

    let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            // Only show the buttons if the duel hasn't started yet.
            if !isDuelStarted {
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

            if isCountingDown {
                Text("Countdown: \(countdown)")
                    .onReceive(countdownTimer) { _ in
                        if countdown > 0 {
                            countdown -= 1
                        } else {
                            isCountingDown = false
                        }
                    }
            } else if countdown == 0 && isDuelStarted {
                Text("DRAW!")
            } else {
                Text(duelResult)
            }
        }
        .onReceive(wcDelegate.$message.compactMap { $0 }) { message in
            if let action = message["action"] as? String {
                let timestamp = Date().timeIntervalSince1970
                wcDelegate.sendMessage(["action": "draw", "timestamp": timestamp])

                switch action {
                case "countdownStart":
                    isDuelStarted = true
                    isCountingDown = true
                    motionManager.startUpdates()
                case "duelResult":
                    if let result = message["result"] as? String {
                        duelResult = result
                        motionManager.stopUpdates()
                    }
                default:
                    break
                }

                let theirTimestamp = message["timestamp"] as? TimeInterval
                let ourTimestamp = Date().timeIntervalSince1970
                let averageTimestamp = ((theirTimestamp ?? <#default value#>) + ourTimestamp) / 2

                if theirTimestamp! < averageTimestamp {
                    // They drew first
                } else {
                    // We drew first
                }
            }
        }
        .onChange(of: isDrawDetected) { drawDetected in
            if drawDetected {
                if isCountingDown {
                    didDrawEarly = true
                    wcDelegate.sendMessage(["action": "earlyDraw"])
                } else if countdown == 0 && !didDrawEarly {
                    let timestamp = Date().timeIntervalSince1970
                    wcDelegate.sendMessage(["action": "draw", "timestamp": timestamp])
                }
            }
        }
    }
}
