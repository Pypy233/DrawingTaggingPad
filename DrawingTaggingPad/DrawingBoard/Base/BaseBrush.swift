//
//  BaseBrush.swift
//  DrawingBoard
// Created by py on 2018/9/3.
//  Copyright © 2018年 NJU.py. All rights reserved.

import CoreGraphics

protocol PaintBrush {
    
    func supportedContinuousDrawing() -> Bool
    
    func drawInContext(_ context: CGContext)
}

class BaseBrush : NSObject, PaintBrush {
    var beginPoint: CGPoint!
    var endPoint: CGPoint!
    var lastPoint: CGPoint?
    
    var strokeWidth: CGFloat!
    
    func supportedContinuousDrawing() -> Bool {
        return false
    }
    
    func drawInContext(_ context: CGContext) {
        assert(false, "must implements in subclass.")
    }
}
