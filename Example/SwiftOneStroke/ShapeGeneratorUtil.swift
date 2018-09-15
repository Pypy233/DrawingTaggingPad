//
//  ShapeGeneratorUtil.swift
//  DrawingTaggingPad
//
//  Created by py on 2018/9/15.
//  Copyright © 2018年 Yu Pan. All rights reserved.
//

import UIKit

class ShapeGenerator {
    var drawingPoints = [StrokePoint]()
    
    func getShapeCenter() -> StrokePoint {
        var strokeBounds = getStrokeBounds()
        let x = (strokeBounds[0].x + strokeBounds[1].x) / 2
        let y = (strokeBounds[2].y + strokeBounds[3].y) / 2
        print("x: \(x) y: \(y)")
        return StrokePoint(x: x, y: y)
    }
    
    
    
    /**
     计算初始点到结束点的距离
     **/
    func getDistanceBetweenStartAndEnd() -> Double {
        assert(drawingPoints.count > 2)
        return drawingPoints[0].distanceTo(drawingPoints.last!)
    }
    
    
    func getStrokeBounds() -> [StrokePoint] {
        let beginPoint = self.drawingPoints[0]
        
        var xMostPoint  = beginPoint
        var xLeastPoint = beginPoint
        var yMostPoint  = beginPoint
        var yLeastPoint = beginPoint // 寻找四个近似切点的位置
        
        
        for point in self.drawingPoints{
            if point.x < xLeastPoint.x{
                xLeastPoint = point
            }
            if point.x > xMostPoint.x{
                xMostPoint.x = point.x
            }
            if point.y < yLeastPoint.y{
                yLeastPoint = point
            }
            if point.y > yMostPoint.y{
                yMostPoint = point
            }
        }
        return [xLeastPoint, xMostPoint, yLeastPoint, yMostPoint]
    }
    

    
    
    
    
}
