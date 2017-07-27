//
//  KerasLetterRecognizer.swift
//  Snowman WatchKit Extension
//
//  Created by Conrad Stoll on 7/26/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import CoreML
import Foundation

class KerasLetterRecognizer : LetterRecognizing {
    let model = letters_keras()
    
    func recognizeLetter(for drawing: LetterDrawing) -> LetterPrediction {
        let inputVector = drawing.generateImageVectorForAlphaChannel()
        
        do {
            let multiArray = try MLMultiArray(shape: [1,28,28], dataType: MLMultiArrayDataType.double)
            
            for (index, number) in inputVector.enumerated() {
                multiArray[index] = number
            }
            
            let prediction = try model.prediction(input1: multiArray)
            let output = prediction.output1
            
            let letter = predictionResult(for: output)
            
            return letter
        } catch {
            print(error)
        }

        return LetterPrediction(letter: "", confidence: 0)
    }
    
    fileprivate func predictionResult(for output : MLMultiArray) -> LetterPrediction {
        var highestIndex = 0
        var highestValue = 0.0
        
        for i in 1..<output.count {
            let firstValue = output[i]
            
            if firstValue.doubleValue > highestValue {
                highestValue = firstValue.doubleValue
                highestIndex = i
            }
        }
        
        let characterIndex = String(highestIndex)
        let letter = characterIndex.letter()
        let confidence = highestValue * 100.0
        
        return LetterPrediction(letter: letter, confidence: confidence)
    }

}
