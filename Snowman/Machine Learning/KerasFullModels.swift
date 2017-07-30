//
//  KerasFullModels.swift
//  Snowman
//
//  Created by Conrad Stoll on 7/28/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import CoreML
import Foundation

let KerasFullAlphabetModel : KerasModel = letters_keras()

extension letters_keras : KerasModel {
    func predictionResult(from inputArray: MLMultiArray) throws -> MLMultiArray {
        let result = try self.prediction(imageAlpha: inputArray)
        let output = result.letterConfidence
        
        return output
    }
}
