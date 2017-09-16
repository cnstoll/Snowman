//
//  GameModeInterfaceController.swift
//  Snowman WatchKit Extension
//
//  Created by Conrad Stoll on 7/5/17.
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

import Foundation
import WatchKit

class GameModeRowController : NSObject {
    @IBOutlet var modeLabel : WKInterfaceLabel!
    
    func update(for mode: GameMode) {
        modeLabel.setText(mode.title)
    }
}

class GameModeInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var table : WKInterfaceTable!
    
    var modes : [GameMode]?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let modes = context as? [GameMode] {
            self.modes = modes
            
            table.setNumberOfRows(modes.count, withRowType: "GameModeRowController")
            
            for index in 0..<table.numberOfRows {
                if let row = table.rowController(at: index) as? GameModeRowController {
                    let mode = modes[index]
                    
                    row.update(for: mode)
                }
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if let mode = modes?[rowIndex] {
            let phrases = mode.phrases
            let total = UInt32(phrases.count)
            let random = Int(arc4random_uniform(total))
            let phrase = phrases[random]
            
            WKInterfaceController.reloadRootPageControllers(withNames: ["GameInterfaceController"], contexts: [phrase], orientation: .horizontal, pageIndex: 0)
        }
    }
}
