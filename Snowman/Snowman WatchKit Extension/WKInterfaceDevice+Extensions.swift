//
//  WKInterfaceDevice+Extensions.swift
//  Snowman WatchKit Extension
//
//  Created by Conrad Stoll on 1/2/19.
//  Copyright © 2019 Conrad Stoll. All rights reserved.
//

import WatchKit

extension WKInterfaceDevice {

    enum WatchResolution : String {
        case Watch38mm, Watch40mm, Watch42mm, Watch44mm, Unknown
    }
    
    class func currentResolution() -> WatchResolution {
        let watch38mmRect = CGRect(x: 0, y: 0, width: 136, height: 170)
        let watch42mmRect = CGRect(x: 0, y: 0, width: 156, height: 195)
        let watch40mmRect = CGRect(x: 0, y: 0, width: 162, height: 197)
        let watch44mmRect = CGRect(x: 0, y: 0, width: 184, height: 224)
        
        let currentBounds = current().screenBounds
        
        switch currentBounds {
        case watch38mmRect:
            return .Watch38mm
        case watch40mmRect:
            return .Watch40mm
        case watch42mmRect:
            return .Watch42mm
        case watch44mmRect:
            return .Watch44mm
        default:
            return .Unknown
        }
    }
    
    class func drawingSize() -> CGSize {
        switch currentResolution() {
        case .Watch38mm:
            return CGSize(width: 134, height: 150)
        case .Watch40mm:
            return CGSize(width: 150, height: 168)
        case .Watch44mm:
            return CGSize(width: 170, height: 192)
        case .Unknown: fallthrough
        case .Watch42mm:
            return CGSize(width: 154, height: 174)
        }
    }
}
