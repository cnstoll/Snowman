//
//  LetterDrawing.swift
//  Snowman WatchKit Extension
//
//  Created by Conrad Stoll on 7/26/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import Foundation
import UIKit

public let LetterDrawingLoggingEnabled = false

protocol LetterDrawing {
    var drawingHeight : CGFloat { get set }
    var drawingWidth : CGFloat { get set }
    var strokeWidth : CGFloat { get set }

    var path : UIBezierPath { get }

    func addPoint(_ point : CGPoint) -> UIBezierPath
    func addSegment()

    func generateImageVectorForAlphaChannel() -> [NSNumber]
}

extension UIImage {
    func pixelAlpha() -> [NSNumber] {
        var pixels = [NSNumber]()
        
        for w in 0...Int(self.size.width) - 1 {
            for h in 0...Int(self.size.height) - 1 {
                let point = CGPoint(x: w, y: h)
                let alpha = getPixelAlphaValue(at: point)
                let number = NSNumber(value: Float(alpha))
                
                pixels.append(number)
            }
        }
        
        return pixels
    }
    
    func crop(rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    func scaleImage() -> UIImage? {
        let newSize = CGSize(width: 28, height: 28)
        let newRect = CGRect(x: 2, y: 2, width: newSize.width - 4.0, height: newSize.height - 4.0).integral
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(self.cgImage!, in: newRect)
            let newImage = UIImage(cgImage: context.makeImage()!)
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
        return nil
    }
    
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(self.cgImage!, in: newRect)
            let newImage = UIImage(cgImage: context.makeImage()!)
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    
    func getPixelAlphaValue(at point: CGPoint) -> CGFloat {
        guard let cgImage = cgImage, let pixelData = cgImage.dataProvider?.data else { return 0.0 }
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        
        let pixelInfo: Int = ((cgImage.bytesPerRow * Int(point.y)) + (Int(point.x) * bytesPerPixel))
        
        // We don't need to know about color for this
        //        let b = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        //        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        //        let r = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        
        // All we need is the alpha values
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return a
    }
}
