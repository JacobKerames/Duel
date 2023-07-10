//
//  DuelView.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 10/19/22.
//

import Combine
import AVFoundation
import WatchKit

class DuelViewModel: ObservableObject {
    // Published properties for managing the duel state
    @Published var duelResult: String = ""
    @Published var countdown = 3
    @Published var isCountingDown = false
    @Published var didDrawEarly = false
    @Published var isDuelStarted = false
    @Published var isDrawDetected = false

    // Timer for countdown
    let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // WatchConnectivity delegate and motion manager
    private let wcService = WatchConnectivityService.shared
    private let motionManager = MotionManager()
    
    // Audio players for sound effects
    private var audioPlayer: AVAudioPlayer?
    private var drawAudioPlayer: AVAudioPlayer?

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Observe the message updates from WatchConnectivity
        wcService.$message.compactMap { $0 }
            .sink(receiveValue: { message in
                if let action = message["action"] as? String {
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
                }
            })
            .store(in: &cancellables)
    }
    
    // Start a duel by sending a "start" message
    func startDuel() {
        wcService.sendMessage(["action": "start"])
    }

    // Join a duel by sending a "connect" message
    func joinDuel() {
        wcService.sendMessage(["action": "connect"])
    }

    // Perform the countdown tick
    func countdownTick() {
        if countdown > 0 {
            countdown -= 1
            if countdown == 5 {
                motionManager.startUpdates()
            }
            playSound()
            playHaptic()
        } else {
            isCountingDown = false
            playSound(for: "draw")
            playHaptic()
        }
    }

    // Handle the draw motion detection
    func drawDetected() {
        if isCountingDown {
            didDrawEarly = true
            wcService.sendMessage(["action": "earlyDraw"])
        } else if countdown == 0 && !didDrawEarly {
            let timestamp = Date().timeIntervalSince1970
            wcService.sendMessage(["action": "draw", "timestamp": timestamp])
            playDrawSound()
            playHaptic()
        }
    }
    
    // Play a sound effect for counting down
    private func playSound(for event: String = "countdown") {
        guard let url = Bundle.main.url(forResource: event, withExtension: "wav") else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Couldn't load sound file")
        }
    }
    
    // Play a sound effect for draw action
    private func playDrawSound() {
        guard let url = Bundle.main.url(forResource: "draw_action", withExtension: "wav") else { return }

        do {
            drawAudioPlayer = try AVAudioPlayer(contentsOf: url)
            drawAudioPlayer?.play()
        } catch {
            print("Couldn't load draw sound file")
        }
    }

    // Play haptic feedback
    private func playHaptic() {
        WKInterfaceDevice.current().play(.click)
    }
}
