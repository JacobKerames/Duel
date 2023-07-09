//
//  DuelView.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 10/19/22.
//

import Foundation
import WatchConnectivity
import Combine

class DuelView: ObservableObject {
    @Published var duelResult: String = ""
    @Published var countdown = 3
    @Published var isCountingDown = false
    @Published var didDrawEarly = false
    @Published var isDuelStarted = false
    @Published var isDrawDetected = false

    let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let wcDelegate = ExtensionDelegate.shared
    private let motionManager = MotionManager()
    
    init() {
        _ = wcDelegate.$message.compactMap { $0 }
            .sink(receiveValue: { message in
                if let action = message["action"] as? String {
                    let timestamp = Date().timeIntervalSince1970
                    self.wcDelegate.sendMessage(["action": "draw", "timestamp": timestamp])

                    switch action {
                    case "countdownStart":
                        self.isDuelStarted = true
                        self.isCountingDown = true
                        self.motionManager.startUpdates()
                    case "duelResult":
                        if let result = message["result"] as? String {
                            self.duelResult = result
                            self.motionManager.stopUpdates()
                        }
                    default:
                        break
                    }

                    let theirTimestamp = message["timestamp"] as? TimeInterval
                    let ourTimestamp = Date().timeIntervalSince1970
                    let averageTimestamp = ((theirTimestamp ?? 0) + ourTimestamp) / 2

                    if theirTimestamp! < averageTimestamp {
                        // They drew first
                    } else {
                        // We drew first
                    }
                }
            })
    }
    
    func startDuel() {
        wcDelegate.sendMessage(["action": "start"])
    }

    func joinDuel() {
        wcDelegate.sendMessage(["action": "connect"])
    }

    func countdownTick() {
        if countdown > 0 {
            countdown -= 1
        } else {
            isCountingDown = false
        }
    }

    func drawDetected() {
        if isCountingDown {
            didDrawEarly = true
            wcDelegate.sendMessage(["action": "earlyDraw"])
        } else if countdown == 0 && !didDrawEarly {
            let timestamp = Date().timeIntervalSince1970
            wcDelegate.sendMessage(["action": "draw", "timestamp": timestamp])
        }
    }
}
