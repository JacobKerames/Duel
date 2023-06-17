//
//  Model.swift
//  Duel Watch App
//
//  Created by Jacob Kerames on 12/5/22.
//

import Foundation
import CoreML

enum ClassifierError : Error {
    case RuntimeError(String)
}

class Classifier: NSObject {
    let model = DrawClassifier1(configuration: MLModelConfiguration)

    private func predict(_ input: MLMultiArray) -> MLMultiArray {
        guard let modelPrediction = try? model.prediction(input: input) else {
            fatalError("Unable to make prediction")
        }
        return modelPrediction.output
    }
    
    public func makePrediction(_ onInputData: MLMultiArray) throws -> Int {
        let modelPrediction: MLMultiArray?
        
        modelPrediction = self.predict(onInputData)
        
        guard   let predictedClassWalk = modelPrediction?[0],
                let predictedClassRun = modelPrediction?[1]
        else {
            throw ClassifierError.RuntimeError("Predicted values are invalid")
        }
        
        return Double(truncating: predictedClassWalk) > Double(truncating: predictedClassRun) ? 0 : 1
    }
}
