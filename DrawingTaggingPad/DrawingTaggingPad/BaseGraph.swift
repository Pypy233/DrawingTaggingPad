//
//  BaseGraph.swift
//  DrawingTaggingPad
//
//  Created by py on 2018/9/4.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import CoreGraphics

protocol drawGraph {
    
    func supportedContinuousDrawing() -> Bool
    
    func drawInContext(context: CGContext)
}

class BaseBrush : NSObject, drawGraph {
    var beginPoint: CGPoint!
    var endPoint: CGPoint!
    var lastPoint: CGPoint?
    
    var strokeWidth: CGFloat!
    
    func supportedContinuousDrawing() -> Bool {
        return false
    }
    
    func drawInContext(context: CGContext) {
        assert(false, "must implements in subclass.")
    }
}
