//
//  MotionManager.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 7/8/23.
//

// MotionManager.swift

import CoreMotion
import CoreML

class MotionManager {
    private let motion = CMMotionManager()
    private let queue = OperationQueue()

    private var model: DrawClassifier?

    // Buffers to hold the last 150 points for each parameter
    private var accelerationX: [Double] = []
    private var accelerationY: [Double] = []
    private var accelerationZ: [Double] = []
    private var rotationX: [Double] = []
    private var rotationY: [Double] = []
    private var rotationZ: [Double] = []

    // LSTM state
    private var stateIn: MLMultiArray?

    init() {
        do {
            let config = MLModelConfiguration()
            model = try DrawClassifier(configuration: config)
            stateIn = try MLMultiArray(shape: [400], dataType: .double)
        } catch {
            print("Failed to initialize model: \(error)")
        }
    }

    // Start collecting motion data
    func startUpdates() {
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1.0 / 60.0  // Update every 60th of a second
            motion.startDeviceMotionUpdates(to: queue) { [weak self] (motion, error) in
                guard let motion = motion else { return }
                self?.processMotion(motion)
            }
        }
    }

    // Stop collecting motion data
    func stopUpdates() {
        if motion.isDeviceMotionAvailable {
            motion.stopDeviceMotionUpdates()
            // Reset LSTM state
            do {
                stateIn = try MLMultiArray(shape: [400], dataType: .double)
            } catch {
                print("Failed to reset LSTM state: \(error)")
            }
        }
    }

    // Process a new motion data point
    private func processMotion(_ motion: CMDeviceMotion) {
        updateBuffers(with: motion)

        guard accelerationX.count == 150 else { return }

        guard let model = model else {
            print("Model is not initialized.")
            return
        }

        do {
            // Initialize an empty MLMultiArray
            let emptyMultiArray = try! MLMultiArray(shape: [400], dataType: .double)

            // Create input for the model
            let input = DrawClassifierInput(
                acceleration_x: try! MLMultiArray(accelerationX),
                acceleration_y: try! MLMultiArray(accelerationY),
                acceleration_z: try! MLMultiArray(accelerationZ),
                rotation_x: try! MLMultiArray(rotationX),
                rotation_y: try! MLMultiArray(rotationY),
                rotation_z: try! MLMultiArray(rotationZ),
                stateIn: stateIn ?? emptyMultiArray
            )

            // Make prediction
            let output = try model.prediction(input: input)

            // Update LSTM state
            stateIn = output.stateOut

            // Check prediction
            if output.label == "left" || output.label == "right" {
                stopUpdates()
                // Notify the rest of your app
            }

        } catch {
            print("Error making prediction: \(error)")
        }
    }

    // Update data buffers with a new data point
    private func updateBuffers(with motion: CMDeviceMotion) {
        accelerationX.append(motion.userAcceleration.x)
        accelerationY.append(motion.userAcceleration.y)
        accelerationZ.append(motion.userAcceleration.z)
        rotationX.append(motion.rotationRate.x)
        rotationY.append(motion.rotationRate.y)
        rotationZ.append(motion.rotationRate.z)

        // If we have more than 150 points, remove the oldest one
        if accelerationX.count > 150 {
            accelerationX.removeFirst()
            accelerationY.removeFirst()
            accelerationZ.removeFirst()
            rotationX.removeFirst()
            rotationY.removeFirst()
            rotationZ.removeFirst()
        }
    }
}
