//
//  InterfaceController.swift
//  Test WatchKit Extension
//
//  Created by Conrad Stoll on 6/11/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import Foundation
import SpriteKit
import WatchKit

class GameInterfaceController: WKInterfaceController {
    
    let recognizer : LetterRecognizing = KerasLetterRecognizer(KerasFullAlphabetModel)
    
    let firstHalfRecognizer : LetterRecognizing = KerasLetterRecognizer(KerasFirstHalfAlphabetModel)
    let secondHalfRecognizer : LetterRecognizing = KerasLetterRecognizer(KerasSecondHalfAlphabetModel)
    
    @IBOutlet weak var mainGroup : WKInterfaceGroup!
    @IBOutlet weak var gameGroup : WKInterfaceGroup!
    @IBOutlet weak var drawGroup : WKInterfaceGroup!
    @IBOutlet weak var confirmGroup : WKInterfaceGroup!
    @IBOutlet weak var playAgainGroup : WKInterfaceGroup!
    @IBOutlet weak var phraseGroup : WKInterfaceGroup!

    @IBOutlet weak var introGroup : WKInterfaceGroup!
    var shownIntro = false
    
    @IBOutlet weak var snowmanImage : WKInterfaceImage!
    @IBOutlet weak var youWon : WKInterfaceLabel!
    @IBOutlet weak var youLost : WKInterfaceLabel!

    @IBOutlet weak var guessingPhrase : WKInterfaceLabel!
    @IBOutlet weak var animationGuessingPhrase : WKInterfaceLabel!

    @IBOutlet weak var missedGuesses : WKInterfaceLabel!
    @IBOutlet weak var animationMissedGuesses : WKInterfaceLabel!

    @IBOutlet weak var finalPhrase : WKInterfaceLabel!
    @IBOutlet weak var retryButton : WKInterfaceButton!
    
    @IBOutlet weak var firstConfirmButton : WKInterfaceButton!
    @IBOutlet weak var secondConfirmButton : WKInterfaceButton!
    
    @IBOutlet weak var drawingOverlayGroup : WKInterfaceGroup!
    @IBOutlet weak var drawScene : WKInterfaceSKScene!
    
    @IBOutlet weak var letterPicker : WKInterfacePicker!
    
    var letterSelection : String = ""
    var letterPredictions : [LetterPrediction]?

    var game = Game(word: "")
    var drawing : LetterDrawing?
    var state : GameState = .game(animated: false, phraseAnimated: false)
    var lineNode : SKShapeNode?
    
    var confirmationTimer : Timer?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        configureUI(for: .intro)
        
        if let phrase = context as? String {
            introGroup.setHidden(false)
            game = Game(word: phrase)
            configureUI(for: state)
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func didAppear() {
        super.didAppear()
        
        WKExtension.shared().isAutorotating = true
    }
    
    override func willDisappear() {
        super.willDisappear()
        
        WKExtension.shared().isAutorotating = false
    }
    
    
    // MARK: UI Update Methods
    
    func dismissIntro() {
        self.shownIntro = true
        self.animate(withDuration: 0.35, animations: {
            self.introGroup.setAlpha(0.0)
        })
    }
    
    func configureUI(for state: GameState) {
        switch state {
        case .intro:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismissIntro()
            }
        case .game(let animated, let phraseAnimated):
            let latestPhrase = game.guessingPhrase()
            let latestMissed = game.missedLetters()
            
            if animated && !game.over {
                animationMissedGuesses.setAlpha(0)
                animationGuessingPhrase.setAlpha(0)
                
                animationMissedGuesses.setAttributedText(latestMissed)
                animationGuessingPhrase.setAttributedText(latestPhrase)
                
                animate(withDuration: 0.5, animations: {
                    if phraseAnimated {
                        self.animationGuessingPhrase.setAlpha(1)
                        self.guessingPhrase.setAlpha(0)
                    } else {
                        self.animationMissedGuesses.setAlpha(1)
                        self.missedGuesses.setAlpha(0)
                    }
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                    self.missedGuesses.setAttributedText(latestMissed)
                    self.guessingPhrase.setAttributedText(latestPhrase)
                    self.missedGuesses.setAlpha(1)
                    self.guessingPhrase.setAlpha(1)
                    self.animationMissedGuesses.setAlpha(0)
                    self.animationGuessingPhrase.setAlpha(0)
                })
            } else {
                missedGuesses.setAttributedText(latestMissed)
                guessingPhrase.setAttributedText(latestPhrase)
            }
            
            setTitle(game.gameProgress())
            finalPhrase.setAttributedText(latestPhrase)
            
            if game.over {
                missedGuesses.setHidden(true)
                playAgainGroup.setHidden(false)
                phraseGroup.setHidden(true)
            } else {
                missedGuesses.setHidden(false)
                playAgainGroup.setHidden(true)
                phraseGroup.setHidden(false)
            }
            
            if game.over && game.won {
                youWon.setHidden(false)
                youLost.setHidden(true)
            } else if game.over && !game.won {
                youWon.setHidden(true)
                youLost.setHidden(false)
            } else {
                youWon.setHidden(true)
                youLost.setHidden(true)
            }
            
            animate(withDuration: 0.5, animations: {
                self.snowmanImage.setImage(self.game.snowman())
            })
            
            drawGroup.setBackgroundImage(nil)
            drawGroup.setHidden(true)
            
            confirmGroup.setHidden(true)
            
            self.drawingOverlayGroup.setAlpha(0.0)
            
            lineNode?.removeFromParent()
            lineNode = nil
            
            letterPicker.resignFocus()
        case .draw:
            drawGroup.setHidden(false)
            confirmGroup.setHidden(true)
            
            // Animate on Series 2
            // It's too slow on Series 0
            
            self.drawingOverlayGroup.setAlpha(0.65)
            
//            self.animate(withDuration: 0.35, animations: {
//                self.drawingOverlayGroup.setAlpha(0.65)
//            })
            
            letterPicker.resignFocus()
        case .confirm:
            confirmGroup.setHidden(false)
            
            self.animate(withDuration: 0.35, animations: {
                self.drawingOverlayGroup.setAlpha(1)
            })
        }
    }
    
    
    // MARK: Action Methods
    
    @IBAction func didTapRetry() {
        state = .game(animated: false, phraseAnimated: false)
        configureUI(for: .game(animated: false, phraseAnimated: false))
    }
    
    @IBAction func didTapFirstConfirm() {
        updateGame(forGuessed: letterSelection)
    }
    
    @IBAction func didTapSecondConfirm() {
        updateGame(forGuessed: letterSelection)
    }
    
    @IBAction func didTapPlayAgain() {
        GameManager.shared.playAgain()
    }
    
    @IBAction func didSelectStartOver() {
        GameManager.shared.playAgain()
    }
    
    @IBAction func didChangePickerIndex(_ index : Int) {
        if let predictions = letterPredictions {
            let letter = predictions[index].letter
            
            firstConfirmButton.setTitle(letter)
            letterSelection = letter
            
            setTitle(game.interfaceTitle(for: letter))
            secondConfirmButton.setBackgroundColor(game.confirmButtonColor(for: letter))
        }
    }
    
    
    // MARK: Gesture Methods
    
    @IBAction func didTap(sender : WKTapGestureRecognizer) {
        guard game.over == false else {
            return
        }
        
        if case .confirm = state {
            return
        }
        
        guard shownIntro else {
            dismissIntro()
            return
        }
        
        if drawing == nil {
            startDrawing()
        }
        
        guard let currentDrawing = drawing else {
            return
        }
        
        startTrackingGesturesForDrawing()
        
        let location = sender.locationInObject()
        
        updateDrawingLine(for: location, currentDrawing: currentDrawing)
        
        addSegmentAndWaitForConfirmation(with: currentDrawing)
    }
    
    @IBAction func didPan(sender : WKPanGestureRecognizer) {
        guard game.over == false else {
            return
        }
        
        if case .confirm = state {
            return
        }
        
        guard shownIntro else {
            dismissIntro()
            return
        }
        
        if drawing == nil, sender.state == .began {
            startDrawing()
        }
        
        guard let currentDrawing = drawing else {
            return
        }
        
        if sender.state == .began {
            startTrackingGesturesForDrawing()
        }
        
        let location = sender.locationInObject()
        
        updateDrawingLine(for: location, currentDrawing: currentDrawing)
        
        if sender.state == .ended {
            addSegmentAndWaitForConfirmation(with: currentDrawing)
        }
    }
    
    func startDrawing() {
        let size = CGSize(width: 154.0, height: 174.0)
        let strokeWidth : CGFloat = 8.0
        
        // Todo: Different canvas sizes for 38mm
        
        drawing = LetterImageDrawing()
        drawing?.drawingWidth = size.width
        drawing?.drawingHeight = size.height
        drawing?.strokeWidth = strokeWidth
        
        let line = SKShapeNode()
        //line.blendMode = .replace  // Doesn't seem to have any effect
        line.fillColor = SKColor.clear
        line.isAntialiased = false
        line.lineWidth = strokeWidth
        line.lineCap = .round
        //line.lineJoin = .round  // Seems to hurt performance
        line.strokeColor = UIColor.white
        lineNode = line
        
        let scene = SKScene(size: size)
        scene.addChild(line)
        scene.backgroundColor = UIColor.clear
        
        drawScene.presentScene(scene)
    }
    
    func startTrackingGesturesForDrawing() {
        configureUI(for: .draw)
        confirmationTimer?.invalidate()
        confirmationTimer = nil
        state = .draw
    }
    
    func updateDrawingLine(for location: CGPoint, currentDrawing: LetterDrawing) {
        let path = currentDrawing.addPoint(location)
        var transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: currentDrawing.drawingHeight)
        let flippedPath = path.cgPath.copy(using: &transform)
        lineNode?.path = flippedPath
    }
    
    func addSegmentAndWaitForConfirmation(with currentDrawing: LetterDrawing) {
        currentDrawing.addSegment()
        
        confirmationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (firedTimer) in
            if firedTimer == self.confirmationTimer {
                self.presentConfirmation()
                self.confirmationTimer = nil
            }
        })
    }
    
    func presentConfirmation() {
        guard let currentDrawing = drawing else {
            didTapRetry()
            return
        }
        
        state = .confirm
        
        let predictions = recognizer.recognizeLetter(for: currentDrawing)
        letterPredictions = predictions
            
        guard let prediction = predictions.first else {
            return
        }
        
        letterSelection = prediction.letter
        
        if (LetterDrawingLoggingEnabled) {
            firstConfirmButton.setTitle(prediction.letter + " " + String(prediction.confidence) + "%")
        } else {
            firstConfirmButton.setTitle(prediction.letter)
        }
        
        setTitle(game.interfaceTitle(for: prediction.letter))

        secondConfirmButton.setBackgroundColor(game.confirmButtonColor(for: prediction.letter))
        
        var pickerItems = [WKPickerItem]()
        
        for item in predictions {
            let pickerItem = WKPickerItem()
            pickerItem.title = item.letter
            pickerItems.append(pickerItem)
        }
        
        self.letterPicker.setItems(pickerItems)
        self.letterPicker.setSelectedItemIndex(0)
        
        if pickerItems.count > 1 {
            self.letterPicker.focus()
        }

        if (LetterDrawingLoggingEnabled) {
            let firstModelGuess = firstHalfRecognizer.recognizeLetter(for: currentDrawing).first!
            let firstModelLetter = firstModelGuess.letter
            let firstModelConfidence = firstModelGuess.confidence
            
            let secondModelGuess = secondHalfRecognizer.recognizeLetter(for: currentDrawing).first!
            let secondModelLetter = secondModelGuess.letter
            let secondModelConfidence = secondModelGuess.confidence
            
            print("First: " + firstModelLetter + " " + String(Int(firstModelConfidence)) + " Second: " + secondModelLetter + " " + String(Int(secondModelConfidence)) + " Full: " + letterSelection + " " + String(Int(prediction.confidence)))
        }
        
        configureUI(for: .confirm)

        drawing = nil
    }
    
    func updateGame(forGuessed letter: String) {
        let repeated = game.repeatedGuess(for: letter)
        let correct = game.evaluate(letter)
        
        if correct {
            //WKInterfaceDevice.current().play(.success)
        } else if !repeated {
            WKInterfaceDevice.current().play(.failure)
        }
        
        state = .game(animated: !repeated, phraseAnimated: correct)
        configureUI(for: .game(animated: !repeated, phraseAnimated: correct))
    }
}
