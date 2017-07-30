//
//  SVMPCAFullModels.swift
//  Snowman
//
//  Created by Conrad Stoll on 7/30/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import CoreML
import Foundation

let SVMPCAFullAlphabetModel : SVMModel = letters_pca()

extension letters_pcaOutput : SVMModelOutput {}

extension letters_pca : SVMModel {
    func predictionResult(from inputArray: MLMultiArray) throws -> SVMModelOutput {
        let result = try self.prediction(convertedPCAValues: inputArray)
        return result
    }
}
