//
//  CoreMLPlaygroundViewController.swift
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
import UIKit

enum CoreMLModelConfiguration : Int {
    case keras
    case kerasHalf
    case pca
    case pcaHalf
    
    func letterPrediction(for drawing : LetterDrawing) -> String {
        switch self {
        case .keras:
            let recognizer = KerasLetterRecognizer(KerasFullAlphabetModel)
            let results = recognizer.recognizeLetter(for: drawing)
            return results.first!.letter
        case .kerasHalf:
            let firstRecognizer = KerasLetterRecognizer(KerasFirstHalfAlphabetModel)
            let firstResults = firstRecognizer.recognizeLetter(for: drawing)
            
            let secondRecognizer = KerasLetterRecognizer(KerasSecondHalfAlphabetModel)
            let secondResults = secondRecognizer.recognizeLetter(for: drawing)

            return firstResults.first!.letter + " | " + secondResults.first!.letter
        case .pca:
            let recognizer = SVMPCALetterRecognizer(SVMPCAFullAlphabetModel)
            let results = recognizer.recognizeLetter(for: drawing)
            
            return results.first!.letter
        case .pcaHalf:
            let firstRecognizer = SVMPCALetterRecognizer(SVMPCAFirstHalfAlphabetModel)
            let firstResults = firstRecognizer.recognizeLetter(for: drawing)
            
            let secondRecognizer = SVMPCALetterRecognizer(SVMPCASecondHalfAlphabetModel)
            let secondResults = secondRecognizer.recognizeLetter(for: drawing)
            
            return firstResults.first!.letter + " | " + secondResults.first!.letter
        }
    }
}

class CoreMLPlaygroundViewController: UIViewController {
    
    @IBOutlet weak var label : UILabel!
    @IBOutlet weak var imageView : UIImageView!
    
    @IBOutlet weak var segmentedControl : UISegmentedControl!
    
    var configuration : CoreMLModelConfiguration = .keras
    var drawing : LetterDrawing?
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didChangeSegmentedControl(sender : UISegmentedControl) {
        configuration = CoreMLModelConfiguration(rawValue: sender.selectedSegmentIndex)!
    }
    
    @IBAction func didPan(gesture : UIPanGestureRecognizer) {
        if drawing == nil {
            drawing = LetterImageDrawing()
            drawing?.drawingWidth = 280.0
            drawing?.drawingHeight = 280.0
            drawing?.strokeWidth = 12.0
        }
        
        guard let currentDrawing = drawing else {
            return
        }
        
        let location = gesture.location(in: gesture.view)
        let path = currentDrawing.addPoint(location)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageView.frame.size.height, height: imageView.frame.size.height), false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setStrokeColor(UIColor.black.cgColor)
        
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = currentDrawing.strokeWidth
        
        path.stroke(with: .normal, alpha: 1)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        imageView.image = image
        
        if gesture.state == .ended {
            label.text = configuration.letterPrediction(for: currentDrawing)
            drawing = nil
        }
    }
}
