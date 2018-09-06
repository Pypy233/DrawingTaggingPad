//
//  TriangleBrush.swift
//  DrawingBoard
//
//  Created by py on 2018/9/6.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

class TriangleBrush: BaseBrush{
    override func drawInContext(_ context: CGContext) {
        let threePointsInTriangle = [CGPoint(x: beginPoint.x, y: beginPoint.y), CGPoint(x: (lastPoint?.x)!, y: (lastPoint?.y)!), CGPoint(x: endPoint.x, y: endPoint.y)]
        context.addLines(between: threePointsInTriangle)
    }
}

