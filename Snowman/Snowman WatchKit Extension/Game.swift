//
//  Game.swift
//  Test WatchKit Extension
//
//  Created by Conrad Stoll on 7/6/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import Foundation
import UIKit

enum GameState {
    case intro
    case game(animated : Bool, phraseAnimated : Bool)
    case draw
    case confirm
}

struct Game {
    let word : String
    
    var correct : [String] = [String]()
    var incorrect : [String] = [String]()
    var won : Bool = false
    var over : Bool = false
    
    init(word : String) {
        self.word = word
    }
    
    private func equivalent(_ character : Character, comparison : String) -> Bool {
        guard let guessedCharacter = comparison.lowercased().characters.first else {
            return false
        }
        
        let string = String(character)
        
        guard let existingCharacter = string.lowercased().characters.first else {
            return false
        }
        
        let result = existingCharacter == guessedCharacter
        
        return result
    }
    
    mutating func evaluate(_ letter : String) -> Bool {
        var correctGuess = false
        
        for character in word.characters {
            if equivalent(character, comparison: letter) {
                correctGuess = true
                break;
            }
        }
        
        if correctGuess == false {
            var repeatGuess = false
            
            for oldGuess in incorrect {
                if oldGuess == letter {
                    repeatGuess = true
                    break;
                }
            }
            
            if repeatGuess == false {
                incorrect.append(letter)
            }
        } else {
            correct.append(letter)
        }
        
        return correctGuess
    }
    
    func snowman() -> UIImage {
        if incorrect.count >= 6 {
            let imageName = "snowman_6"
            let image = UIImage(named: imageName)
            
            return image!
        }
        
        let incorrectCount = String(incorrect.count)
        let imageName = "snowman_" + incorrectCount
        let image = UIImage(named: imageName)
        
        return image!
    }
    
    mutating func gameProgress() -> String {
        if incorrect.count >= 6 {
            over = true
            return "Game Over"
        }
        
        var progress = String(6 - incorrect.count) + " Left"
        
        if won {
            progress = "You Won!"
        }
        
        return progress
    }
    
    mutating func guessingPhrase() -> NSAttributedString {
        let shouldRevealPhrase = incorrect.count >= 6
        
        var phrase = ""
        
        var gameWon = true
        
        for character in word.characters {
            if character == " " {
                phrase += " "
            } else if character == "-" {
                phrase += "-"
            } else if character == "'" {
                phrase += "'"
            } else {
                var revealed = false
                
                for letter in correct {
                    if equivalent(character, comparison: letter) || shouldRevealPhrase {
                        phrase += String(character)
                        revealed = true
                        break
                    }
                }
                
                if revealed == false {
                    phrase += "_"
                    gameWon = false
                }
            }
        }
        
        if gameWon {
            over = true
            won = true
        }
        
        if shouldRevealPhrase {
            won = false
        }
        
        return kerningAttributed(for: phrase)
    }
    
    func missedGuesses() -> NSAttributedString {
        let missed = incorrect.reduce("", {$0 + $1})
        
        return kerningAttributed(for: missed)
    }
    
    private func kerningAttributed(for string : String) -> NSAttributedString {
        let attributedString = NSAttributedString(string: string, attributes: [NSAttributedStringKey.kern : NSNumber(value: 2), NSAttributedStringKey.ligature : NSNumber(value: 0)])
        return attributedString
    }
}
