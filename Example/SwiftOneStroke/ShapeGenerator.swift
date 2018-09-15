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
    
    func getPermiter(shapeType: ShapeView.ShapeType) -> [Double] {
        let xLeastPoint = getStrokeBounds()[0]
        let xMostPoint  = getStrokeBounds()[1]
        let yLestPoint  = getStrokeBounds()[2]
        let yMostPoint  = getStrokeBounds()[3]
        
        var permiterArray = [Double]()
        
        switch shapeType {
        case .Circle:
            permiterArray.append(getAveragePermiter(point1: xLeastPoint, point2: xMostPoint, point3: yLestPoint, point4: yMostPoint))
            return permiterArray
            
        case .Rectangle:
            let width =  getAveragePermiter(point1: yLestPoint, point2: xMostPoint, point3: xLeastPoint, point4: yMostPoint)
            let height = getAveragePermiter(point1: xLeastPoint, point2: yLestPoint, point3: xMostPoint, point4: yMostPoint)
            permiterArray.append(width)
            permiterArray.append(height)
            return permiterArray
            
        case .Triangle:
            permiterArray.append(xLeastPoint.distanceTo(xMostPoint))
            permiterArray.append(yLestPoint.distanceTo(yMostPoint))
            permiterArray.append(getAveragePermiter(point1: yMostPoint, point2: xLeastPoint, point3: yMostPoint, point4: xMostPoint))
            return permiterArray
            
        default:
            let width =  getAveragePermiter(point1: yLestPoint, point2: xMostPoint, point3: xLeastPoint, point4: yMostPoint)
            let height = getAveragePermiter(point1: xLeastPoint, point2: yLestPoint, point3: xMostPoint, point4: yMostPoint)
            permiterArray.append((width + height) / 2)
            return permiterArray
        }
    }
    
    
    /** 
     两边取平均
     **/
    func getAveragePermiter(point1: StrokePoint, point2
        : StrokePoint, point3: StrokePoint, point4: StrokePoint) -> Double {
        return (point1.distanceTo(point2) + point3.distanceTo(point4)) / 2
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
