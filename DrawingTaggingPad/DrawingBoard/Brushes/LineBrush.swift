//
//  LineBrush.swift
//  DrawingBoard
//
//  Created by py on 2018/9/3.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

class LineBrush: BaseBrush {
    
    override func drawInContext(_ context: CGContext) {
        context.move(to: CGPoint(x: beginPoint.x, y: beginPoint.y))
        context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
    }
}
