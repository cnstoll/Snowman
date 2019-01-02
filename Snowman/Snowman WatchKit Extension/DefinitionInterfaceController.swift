//
//  DefinitionInterfaceController.swift
//  Snowman WatchKit Extension
//
//  Created by Conrad Stoll on 1/2/19.
//  Copyright © 2019 Conrad Stoll. All rights reserved.
//

import Foundation
import WatchKit

class DefinitionInterfaceController : WKInterfaceController {
    
    @IBOutlet weak var label : WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        if let text = context as? String {
            label.setText(text)
        }
        
        setTitle("Done")
    }
}
