//
//  LetterRecognizing.swift
//  Snowman WatchKit Extension
//
//  Created by Conrad Stoll on 7/26/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import CoreML
import Foundation

struct LetterPrediction {
    let letter : String
    let confidence : Double?
}

protocol LetterRecognizing {
    func recognizeLetter(for drawing : LetterDrawing) -> LetterPrediction
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
