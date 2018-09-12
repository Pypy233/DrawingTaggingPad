//
//  PencilBrush.swift
//  DrawingBoard
//
//  Created by py on 2018/9/3.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

class PencilBrush: BaseBrush {
    
    override func drawInContext(_ context: CGContext) {
        if let lastPoint = self.lastPoint {
            context.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        } else {
            context.move(to: CGPoint(x: beginPoint.x, y: beginPoint.y))
            context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        }
    }
    
    override func supportedContinuousDrawing() -> Bool {
        return true
    }
    
}
