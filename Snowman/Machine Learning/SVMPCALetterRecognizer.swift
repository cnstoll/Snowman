//
//  SVMPCALetterRecognizer.swift
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

import Accelerate
import CoreML
import Foundation

protocol SVMModel {
    func predictionResult(from inputArray: MLMultiArray) throws -> SVMModelOutput
}

protocol SVMModelOutput {
    var letterIndex : Int64 { get }
    var classProbability: [Int64 : Double] { get }
}

class SVMPCALetterRecognizer : LetterRecognizing {
    
    let model : SVMModel
    
    init(_ model : SVMModel) {
        self.model = model
    }
    
    func recognizeLetter(for drawing: LetterDrawing) -> [LetterPrediction] {
        let pixelAlpha = drawing.generateImageVectorForAlphaChannel()
        let inputVector = PCAMatrix.shared.transform(from: pixelAlpha)
        
        do {
            let multiArray = try MLMultiArray(shape: [25], dataType: MLMultiArrayDataType.float32)

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
    
    fileprivate func letterPredictions(from output : SVMModelOutput) -> [LetterPrediction] {
        var predictions = [LetterPrediction]()
        
        for i in 1...letterMapping.count {
            let index = Int64(i)
            
            let confidence = output.classProbability[index] ?? 0.0
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

fileprivate class PCAMatrix {
    static let shared = PCAMatrix()
    
    let pca : [Float]
    
    init() {
        pca = PCAMatrix.loadPCAFromCSV()
    }
    
    static func loadPCAFromCSV() -> [Float] {
        let path = Bundle.main.path(forResource: "pca", ofType: "csv")!
        let stream = InputStream(fileAtPath: path)!
        let csv = try! CSVReader(stream: stream)
        
        var matrix : [Float] = [Float]()
        
        var arrays : [[Float]] = [[Float]]()
        
        while let row = csv.next() {
            var array = [Float]()
            
            for item in row {
                let number = Float(item) ?? 0.0
                array.append(number)
            }
            
            arrays.append(array)
        }
        
        var pcaString = ""
        
        for w in 0...Int(784) - 1 {
            for h in 0...Int(25) - 1 {
                let number = arrays[h][w]
                matrix.append(number)
                pcaString += String(number) + ","
            }
        }
        
        return matrix
    }
    
    // Input: 784
    // Output: 25
    fileprivate func transform(from input: [NSNumber]) -> [NSNumber] {
        
        let image = input.map { $0.floatValue }
        var result = [Float](repeating: 0.0, count: 25)
        
        vDSP_mmul(image, 1, pca, 1, &result, 1, 1, 25, 784)
        
        print(result)
        
        let transformed = result.map { NSNumber(value: $0) }
        
        return transformed
    }
}
