//
//  Model.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 12/5/22.
//

import CoreML

class ModelHandler {
    let model: YourActivityClassifierModel

    init() {
        do {
            model = try YourActivityClassifierModel()
        } catch {
            fatalError("Could not initialize model: \(error)")
        }
    }
}

func prepareInputData(_ data: YourInputDataType) -> MLMultiArray {
    // Convert your data into an MLMultiArray.
    // This will depend on the specifics of your data and model.
}
