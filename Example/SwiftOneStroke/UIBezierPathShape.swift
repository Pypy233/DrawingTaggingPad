//
//  UIBezierPathShape.swift
//  SwiftOneStroke
//
//  Created by py on 2018/9/8.
//  Copyright © 2018年 Yu Pan. All rights reserved.
//

import Foundation
import UIKit

class UIBezierPathShapeGenerator{
    var center = CGPoint()
    var path = UIBezierPath()
    
    func trainglePathWithCenter(side: CGFloat) -> UIBezierPath {
        let trianglePath = self.path
        let startX = self.center.x - side / 2
        let startY = self.center.y - side / 2
        
        trianglePath.move(to: CGPoint(x: startX, y: startY))
        trianglePath.addLine(to: CGPoint(x: startX, y: startY + side))
        trianglePath.addLine(to: CGPoint(x: startX + side, y: startY + side/2))
        trianglePath.close()
        
        return trianglePath
    }
    
    
    func circlePathWithCenter(radius: CGFloat) -> UIBezierPath {
        let circlePath = self.path
        circlePath.addArc(withCenter: self.center, radius: radius, startAngle: -CGFloat(Double.pi), endAngle: -CGFloat(Double.pi/2), clockwise: true)
        circlePath.addArc(withCenter: self.center, radius: radius, startAngle: -CGFloat(Double.pi/2), endAngle: 0, clockwise: true)
        circlePath.addArc(withCenter: self.center, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
        circlePath.addArc(withCenter: self.center, radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: true)
        circlePath.close()
        return circlePath
    }
    
    func squarePathWithCenter(side: CGFloat) -> UIBezierPath {
       return rectanglePathWithCenter(width: side, height: side)
    }
    
    func rectanglePathWithCenter(width: CGFloat, height: CGFloat) -> UIBezierPath {
        let rectanglePath = self.path
        let startX = self.center.x - width / 2
        let startY = self.center.y - height / 2
        
        rectanglePath.move(to: CGPoint(x: startX, y: startY))
        rectanglePath.addLine(to: rectanglePath.currentPoint)
        rectanglePath.addLine(to: CGPoint(x: startX + width, y: startY))
        rectanglePath.addLine(to: rectanglePath.currentPoint)
        rectanglePath.addLine(to: CGPoint(x: startX + width, y: startY + height))
        rectanglePath.addLine(to: rectanglePath.currentPoint)
        rectanglePath.addLine(to: CGPoint(x: startX, y: startY + height))
        rectanglePath.addLine(to: rectanglePath.currentPoint)
            rectanglePath.close()
        return rectanglePath

    }
    
}
