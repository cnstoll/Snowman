//
//  LetterImageDrawing.swift
//  Snowman WatchKit Extension
//
//  Created by Conrad Stoll on 7/26/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import Foundation
import UIKit

class LetterImageDrawing : LetterDrawing {
    var drawingHeight : CGFloat = 280.0
    var drawingWidth : CGFloat = 280.0
    var strokeWidth : CGFloat = 12.0

    var path = UIBezierPath()
    
    fileprivate var minY : CGFloat?
    fileprivate var maxY : CGFloat?
    
    fileprivate var minX : CGFloat?
    fileprivate var maxX : CGFloat?
    
    fileprivate var segments : [[CGPoint]] = [[CGPoint]]()
    fileprivate var points : [CGPoint] = [CGPoint]()
    
    func addSegment() {
        segments.append(points)
        points = [CGPoint]()
    }
    
    func addPoint(_ point : CGPoint) -> UIBezierPath {
        evaluateMinMax(for: point)
        
        if points.count == 0 {
            path.move(to: point)
        } else {
            path.addLine(to: point)
        }
        
        points.append(point)
        
        return path
    }
    
    func cropRect() -> CGRect {
        var xOffset : CGFloat = 0.0
        var yOffset : CGFloat = 0.0
        var cropWidth : CGFloat = drawingWidth
        var cropHeight : CGFloat = drawingHeight
        
        if let left = minX, let right = maxX {
            cropWidth = right - left + strokeWidth
            xOffset = left - (strokeWidth / 2.0)
        }
        
        if let top = minY, let bottom = maxY {
            cropHeight = bottom - top + strokeWidth
            yOffset = top - (strokeWidth / 2.0)
        }
        
        if cropWidth > cropHeight {
            let offset = (cropWidth - cropHeight) / 2
            yOffset = yOffset - offset
            cropHeight = cropWidth
        }
        
        if cropHeight > cropWidth {
            let offset = (cropHeight - cropWidth) / 2
            xOffset = xOffset - offset
            cropWidth = cropHeight
        }
        
        return CGRect(x: xOffset, y: yOffset, width: cropWidth, height: cropHeight)
    }
    
    func evaluateMinMax(for location : CGPoint) {
        if let x = maxX, location.x > x {
            maxX = location.x
        } else if maxX == nil {
            maxX = location.x
        }
        
        if let x = minX, location.x < x {
            minX = location.x
        } else if minX == nil {
            minX = location.x
        }
        
        if let y = maxY, location.y > y {
            maxY = location.y
        } else if maxY == nil {
            maxY = location.y
        }
        
        if let y = minY, location.y < y {
            minY = location.y
        } else if minY == nil {
            minY = location.y
        }
    }
    
    func generateImageVectorForAlphaChannel() -> [NSNumber] {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: drawingWidth, height: drawingHeight), false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setStrokeColor(UIColor.black.cgColor)
        
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = strokeWidth
        path.stroke(with: .normal, alpha: 1)
        
        let rect = cropRect()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        let cropped = image.crop(rect: rect)
        let scaled = cropped.scaleImage()
        
        let pixels = scaled?.pixelAlpha() ?? [NSNumber]()
        
        if (LetterDrawingLoggingEnabled) {
            logPixelOutput(from: pixels)
        }
        
        return pixels
    }
}

fileprivate extension LetterImageDrawing {
    func logPixelOutput(from pixels : [NSNumber]) {
        var printString = ""
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        
        for (index, number) in pixels.enumerated() {
            if number.doubleValue == 0.0 {
                printString = printString + "-.--" + "  "
            } else {
                printString = printString + formatter.string(from: number)! + "  "
            }
            
            if index % 28 == 0, index > 0 {
                print(printString + "\n")
                printString = ""
            }
        }
    }
}
