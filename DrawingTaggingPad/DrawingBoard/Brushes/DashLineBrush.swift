//
//  DashLineBrush.swift
//  DrawingBoard
//
//  Created by py on 2018/9/3.
//  Copyright © 2018年 NJU.py. All rights reserved.

//

import UIKit

class DashLineBrush: BaseBrush {
    
    override func drawInContext(_ context: CGContext) {
        let _: [CGFloat] = [self.strokeWidth * 3, self.strokeWidth * 3]
                
        context.move(to: CGPoint(x: beginPoint.x, y: beginPoint.y))
        context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
    }
}
