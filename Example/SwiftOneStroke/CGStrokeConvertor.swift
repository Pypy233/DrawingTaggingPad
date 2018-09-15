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
class CGStrokeConvertorUtil {
    
    static func CGPointToStrokePoint(cgPoint: CGPoint) -> StrokePoint {
        let strokePoint = StrokePoint(x: Double(cgPoint.x), y: Double(cgPoint.y))
        return strokePoint
    }
    
    static func strokePointToCGPoint(strokePoint: StrokePoint) -> CGPoint {
        let cgPoint = CGPoint(x: strokePoint.x, y: strokePoint.y)
        return cgPoint
    }

}
