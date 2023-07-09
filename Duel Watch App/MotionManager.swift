//
//  MotionManager.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 7/8/23.
//

import CoreMotion

class MotionManager: ObservableObject {
    
    private let motion = CMMotionManager()
    private let queue = OperationQueue()
    
    // This variable holds the last recorded motion date
    @Published var lastMotionDate: Date?
    
    init() {
        motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
        motion.gyroUpdateInterval = 1.0 / 60.0
        motion.deviceMotionUpdateInterval = 1.0 / 60.0
    }
    
    func startUpdates() {
        if motion.isDeviceMotionAvailable {
            motion.startDeviceMotionUpdates(to: queue) { [weak self] (data, error) in
                guard let data = data else { return }
                self?.handleMotion(data)
            }
        }
    }
    
    func stopUpdates() {
        if motion.isDeviceMotionAvailable {
            motion.stopDeviceMotionUpdates()
        }
    }
    
    private func handleMotion(_ motionData: CMDeviceMotion) {
        // Here you should implement your model to classify the draw motion.
        // Once the draw motion is detected, set the lastMotionDate to the current date
        // I've put a placeholder if condition here. You should replace this with your actual condition
        // based on the ML model you have.
        if motionData.userAcceleration.x > 1.0 { // replace this condition with your draw motion detection logic
            lastMotionDate = Date()
        }
    }
}
