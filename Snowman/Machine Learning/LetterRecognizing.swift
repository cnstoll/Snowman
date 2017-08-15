//
//  LetterRecognizing.swift
//  Snowman WatchKit Extension
//
//  Created by Conrad Stoll on 7/26/17.
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

struct LetterPrediction {
    let letter : String
    let confidence : Double
}

protocol LetterRecognizing {
    func recognizeLetter(for drawing : LetterDrawing) -> [LetterPrediction]
}

let letterMapping = ["1" : "A",
                     "2" : "B",
                     "3" : "C",
                     "4" : "D",
                     "5" : "E",
                     "6" : "F",
                     "7" : "G",
                     "8" : "H",
                     "9" : "I",
                     "10" : "J",
                     "11" : "K",
                     "12" : "L",
                     "13" : "M",
                     "14" : "N",
                     "15" : "O",
                     "16" : "P",
                     "17" : "Q",
                     "18" : "R",
                     "19" : "S",
                     "20" : "T",
                     "21" : "U",
                     "22" : "V",
                     "23" : "W",
                     "24" : "X",
                     "25" : "Y",
                     "26" : "Z"]

extension String {
    func letter() -> String {
        if let result = letterMapping[self] {
            return result
        }
        
        return self
    }
}
