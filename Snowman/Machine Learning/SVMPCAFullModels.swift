//
//  SVMPCAFullModels.swift
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

let SVMPCAFullAlphabetModel : SVMModel = letters_pca()

extension letters_pcaOutput : SVMModelOutput {}

extension letters_pca : SVMModel {
    func predictionResult(from inputArray: MLMultiArray) throws -> SVMModelOutput {
        let result = try self.prediction(convertedPCAValues: inputArray)
        return result
    }
}
