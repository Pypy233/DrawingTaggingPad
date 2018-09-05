//
//  Pencil.swift
//  DrawingTaggingPad
//
//  Created by py on 2018/9/4.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

class Pencil: Shape {
    
    override func supportedContinuousDrawing() -> Bool {
        return true
    }
    
    override func drawInContext(context: CGContext) {
        if let point = self.lastPoint{
           // CGContext?.move(to: CGPoint(x: point.x, y: point.y))
        }
    }
    
    
}
