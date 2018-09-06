//
//  EllipseBrush.swift
//  DrawingBoard
//
//  Created by py on 2018/9/3.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

class EllipseBrush: BaseBrush {
   
    override func drawInContext(_ context: CGContext) {
        context.addEllipse(in: CGRect(origin: CGPoint(x: min(beginPoint.x, endPoint.x), y: min(beginPoint.y, endPoint.y)),
            size: CGSize(width: abs(endPoint.x - beginPoint.x), height: abs(endPoint.y - beginPoint.y))))
    }
}