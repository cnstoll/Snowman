//
//  KerasHalfModels.swift
//  Snowman
//
//  Created by Conrad Stoll on 7/30/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
