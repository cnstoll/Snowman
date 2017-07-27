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
    
    let recognizer : LetterRecognizing = KerasLetterRecognizer()
    
    @IBOutlet weak var mainGroup : WKInterfaceGroup!
    @IBOutlet weak var gameGroup : WKInterfaceGroup!
    @IBOutlet weak var drawGroup : WKInterfaceGroup!
    @IBOutlet weak var confirmGroup : WKInterfaceGroup!
    @IBOutlet weak var playAgainGroup : WKInterfaceGroup!
    
    @IBOutlet weak var introGroup : WKInterfaceGroup!
    var shownIntro = false
    
    @IBOutlet weak var snowmanImage : WKInterfaceImage!
    @IBOutlet weak var guessingPhrase : WKInterfaceLabel!
    @IBOutlet weak var missedGuesses : WKInterfaceLabel!
    
    @IBOutlet weak var retryButton : WKInterfaceButton!
    
    @IBOutlet weak var firstConfirmButton : WKInterfaceButton!
    @IBOutlet weak var secondConfirmButton : WKInterfaceButton!
    
    @IBOutlet weak var drawingOverlayGroup : WKInterfaceGroup!
    @IBOutlet weak var drawScene : WKInterfaceSKScene!
    
    var firstLetter : String = ""
    var secondLetter : String = ""
    
    var game = Game(word: "")
    var drawing : LetterDrawing?
    var state : GameState = .game
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
        case .game:
            guessingPhrase.setAttributedText(game.guessingPhrase())
            setTitle(game.gameProgress())
            missedGuesses.setAttributedText(game.missedGuesses())
            
            if game.over {
                snowmanImage.setHidden(true)
                playAgainGroup.setHidden(false)
            } else {
                snowmanImage.setHidden(false)
                playAgainGroup.setHidden(true)
            }
            
            snowmanImage.setImage(game.snowman())
            
            drawGroup.setBackgroundImage(nil)
            drawGroup.setHidden(true)
            
            confirmGroup.setHidden(true)
            
            self.drawingOverlayGroup.setAlpha(0.0)
            
            lineNode?.removeFromParent()
            lineNode = nil
        case .draw:
            drawGroup.setHidden(false)
            confirmGroup.setHidden(true)
            
            // Animate on Series 2
            // It's too slow on Series 0
            
            self.drawingOverlayGroup.setAlpha(0.65)
            
//            self.animate(withDuration: 0.35, animations: {
//                self.drawingOverlayGroup.setAlpha(0.65)
//            })
        case .confirm:
            confirmGroup.setHidden(false)
            
            self.animate(withDuration: 0.35, animations: {
                self.drawingOverlayGroup.setAlpha(1)
            })
        }
    }
    
    
    // MARK: Action Methods
    
    @IBAction func didTapRetry() {
        state = .game
        configureUI(for: .game)
    }
    
    @IBAction func didTapFirstConfirm() {
        updateGame(forGuessed: firstLetter)
    }
    
    @IBAction func didTapSecondConfirm() {
        updateGame(forGuessed: secondLetter)
    }
    
    @IBAction func didTapPlayAgain() {
        GameManager.shared.playAgain()
    }
    
    @IBAction func didSelectStartOver() {
        GameManager.shared.playAgain()
    }
    
    
    // MARK: Gesture Methods
    
    @IBAction func didTap(sender : WKTapGestureRecognizer) {
        guard game.over == false else {
            return
        }
        
        guard state != .confirm else {
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
        
        guard state != .confirm else {
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
        
        let prediction = recognizer.recognizeLetter(for: currentDrawing)
                
        firstLetter = prediction.letter
        
        if (LetterDrawingLoggingEnabled) {
            firstConfirmButton.setTitle(firstLetter + " " + String(prediction.confidence!) + "%")
        } else {
            firstConfirmButton.setTitle(firstLetter)
        }
        
        configureUI(for: .confirm)

        drawing = nil
    }
    
    func updateGame(forGuessed letter: String) {
        let correct = game.evaluate(letter)
        
        if correct {
            //WKInterfaceDevice.current().play(.success)
        } else {
            WKInterfaceDevice.current().play(.failure)
        }
        
        state = .game
        configureUI(for: .game)
    }
}
