//
//  ShapeView.swift
//  SwiftOneStroke
//
//  Created by py on 2018/9/9.
//  Copyright © 2018年 danielemargutti. All rights reserved.
//

import UIKit



class ShapeView: UIView {
    enum ShapeType {
        case Rectangle, Triangle, Circle, Square
    }
    
    var currentShapeType: ShapeType = ShapeType.Circle
    
    var centerPoint = CGPoint()
    var permiterArray = [CGFloat]()
    
    init(frame: CGRect, shape: ShapeType) {
        super.init(frame: frame)
        self.currentShapeType = shape
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        switch self.currentShapeType {
        case ShapeType.Rectangle: drawRectangle(isSquare: false)
        case ShapeType.Triangle: drawTriangle()
        case ShapeType.Circle: drawCircle()
        case ShapeType.Square: drawRectangle(isSquare: true)
        }
    }
    
    func drawRectangle(isSquare: Bool) {
    //    let centerPoint = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
        let rectangleWidth: CGFloat
        let rectangleHeight: CGFloat
        if isSquare{
                rectangleHeight = permiterArray[0]
                rectangleWidth = permiterArray[1]
        }else{
            rectangleWidth = permiterArray[0]
            rectangleHeight = permiterArray[1]
        }
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        //4
        ctx.addRect(CGRect(x: self.centerPoint.x - (0.5 * rectangleWidth), y: self.centerPoint.y - (0.5 * rectangleHeight), width: rectangleWidth, height: rectangleHeight))
        ctx.setLineWidth(10)
        ctx.setStrokeColor(UIColor.gray.cgColor)
        ctx.strokePath()
        
        //5
        ctx.setFillColor(UIColor.green.cgColor)
        
        ctx.addRect(CGRect(x: centerPoint.x - (0.5 * rectangleWidth), y: centerPoint.y - (0.5 * rectangleHeight), width: rectangleWidth, height: rectangleHeight))
        
        ctx.fillPath()
    }
    
    func drawCircle() {
        let centerPoint = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0);
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.beginPath()
        
        //6
        ctx.setLineWidth(5)
        
        let radius: CGFloat = permiterArray[0]
        let endAngle: CGFloat = CGFloat(2 * Double.pi)
        
        ctx.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
        
        ctx.strokePath()
    }
    
    func drawTriangle() {
       // guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        
    }
    
}
