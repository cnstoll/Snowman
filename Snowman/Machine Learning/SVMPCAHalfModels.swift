//
//  SVMPCAHalfModels.swift
//  Snowman
//
//  Created by Conrad Stoll on 7/30/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import CoreML
import Foundation

let SVMPCAFirstHalfAlphabetModel : SVMModel = letters_pca_half_1()
let SVMPCASecondHalfAlphabetModel : SVMModel = letters_pca_half_2()

extension letters_pca_half_1Output : SVMModelOutput {}

extension letters_pca_half_1 : SVMModel {
    func predictionResult(from inputArray: MLMultiArray) throws -> SVMModelOutput {
        let result = try self.prediction(convertedPCAValues: inputArray)
        return result
    }
}

extension letters_pca_half_2Output : SVMModelOutput {}

extension letters_pca_half_2 : SVMModel {
    func predictionResult(from inputArray: MLMultiArray) throws -> SVMModelOutput {
        let result = try self.prediction(convertedPCAValues: inputArray)
        return result
    }
}
