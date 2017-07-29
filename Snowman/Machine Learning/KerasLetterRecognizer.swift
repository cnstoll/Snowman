//
//  KerasLetterRecognizer.swift
//  Snowman WatchKit Extension
//
//  Created by Conrad Stoll on 7/26/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import CoreML
import Foundation

protocol KerasModel {
    func predictionResult(from inputArray: MLMultiArray) throws -> MLMultiArray
}

class KerasLetterRecognizer : LetterRecognizing {
    
    let model : KerasModel
    
    init(_ model : KerasModel) {
        self.model = model
    }

    func recognizeLetter(for drawing: LetterDrawing) -> [LetterPrediction] {
        let inputVector = drawing.generateImageVectorForAlphaChannel()
        
        do {
            let multiArray = try MLMultiArray(shape: [1,28,28], dataType: MLMultiArrayDataType.double)
            
            for (index, number) in inputVector.enumerated() {
                multiArray[index] = number
            }
            
            let prediction = try model.predictionResult(from: multiArray)

            let predictions = letterPredictions(from: prediction)
            
            return predictions
        } catch {
            print(error)
        }
        
        return [LetterPrediction]()
    }
    
    fileprivate func letterPredictions(from output : MLMultiArray) -> [LetterPrediction] {
        var predictions = [LetterPrediction]()
        
        for i in 1..<output.count {
            let confidence = output[i].doubleValue
            let letter = String(i).letter()
            let prediction = LetterPrediction(letter: letter, confidence: confidence)
            
            predictions.append(prediction)
        }
        
        let sortedPredictions = predictions.sorted { (p1, p2) -> Bool in
            return p1.confidence > p2.confidence
        }
        
        let filteredPredictions = sortedPredictions.filter { (p) -> Bool in
            return p.confidence > 0.05
        }
        
        return filteredPredictions
    }
}
