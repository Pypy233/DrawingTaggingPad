//
//  Pencil.swift
//  DrawingTaggingPad
//
//  Created by py on 2018/9/4.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

class Pencil: Shape {
        override func drawInContext(context: CGContext) {
        let context = UIGraphicsGetCurrentContext()
        if let lastPoint = self.lastPoint {
            
            context?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context?.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
            context?.strokePath()
        } else {
            context?.move(to: CGPoint(x: beginPoint.x, y: beginPoint.y))
            context?.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
            context?.strokePath()
        }
    }
    
    override func supportedContinuousDrawing() -> Bool {
        return true
    }
}
