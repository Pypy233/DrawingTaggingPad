//
//  CGStrokeConvertorUtil.swift
//  DrawingTaggingPad
//
//  Created by py on 2018/9/15.
//  Copyright © 2018年 Yu Pan. All rights reserved.
//

import CoreGraphics

/**
 Stroke 和 Core Graphics 点大致精确的转换器
 **/
class CGStrokeConvertor {
    
    static func CGPointToStrokePoint(cgPoint: CGPoint) -> StrokePoint {
        let strokePoint = StrokePoint(x: Double(cgPoint.x), y: Double(cgPoint.y))
        return strokePoint
    }
    
    static func strokePointToCGPoint(strokePoint: StrokePoint) -> CGPoint {
        let cgPoint = CGPoint(x: strokePoint.x, y: strokePoint.y)
        return cgPoint
    }
    
    static func strokePointsListToCGPointsList(strokePointList: [StrokePoint]) -> [CGPoint] {
        var cgPointList = [CGPoint]()
        for point in strokePointList{
            cgPointList.append(strokePointToCGPoint(strokePoint: point))
        }
        return cgPointList
    }
    
    static func cgPointsListToStrokePointsList(cgPointList: [CGPoint]) -> [StrokePoint] {
        var strokePointList = [StrokePoint]()
        for point in cgPointList {
            strokePointList.append(CGPointToStrokePoint(cgPoint: point))
        }
        return strokePointList
    }

}
