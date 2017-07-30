//
//  KerasHalfModels.swift
//  Snowman
//
//  Created by Conrad Stoll on 7/30/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import CoreML
import Foundation

let KerasFirstHalfAlphabetModel : KerasModel = letters_keras_half_1()
let KerasSecondHalfAlphabetModel : KerasModel = letters_keras_half_2()

extension letters_keras_half_1 : KerasModel {
    func predictionResult(from inputArray: MLMultiArray) throws -> MLMultiArray {
        let result = try self.prediction(imageAlpha: inputArray)
        let output = result.letterConfidence
        
        return output
    }
}

extension letters_keras_half_2 : KerasModel {
    func predictionResult(from inputArray: MLMultiArray) throws -> MLMultiArray {
        let result = try self.prediction(imageAlpha: inputArray)
        let output = result.letterConfidence
        
        return output
    }
}
