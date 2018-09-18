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
    var drawingPoints = [CGPoint]()
    
    var centerPoint = CGPoint()
    var permiterArray = [CGFloat]()
    
    init(frame: CGRect, shape: ShapeType) {
        super.init(frame: frame)
        self.currentShapeType = shape
    }
    
    init(frame: CGRect, shape: ShapeType, drawingPoints: [CGPoint]) {
        super.init(frame: frame)
        self.currentShapeType = shape
        self.drawingPoints = drawingPoints
        //print(self.drawingPoints)
        let strokeDrawingPoints = CGStrokeConvertor.cgPointsListToStrokePointsList(cgPointList: drawingPoints)
        let strokePoint = ShapeGenerator().getShapeCenter(drawingPoints: strokeDrawingPoints, shapeType: shape)
        self.centerPoint = CGStrokeConvertor.strokePointToCGPoint(strokePoint: strokePoint)
        print("*************")
        print(self.centerPoint)
        self.permiterArray = ShapeGenerator().getPermiter(shapeType: self.currentShapeType, drawingPoints: CGStrokeConvertor.cgPointsListToStrokePointsList(cgPointList: drawingPoints))
    }
    
    func getDrawnPoints() -> [StrokePoint] {
        return CGStrokeConvertor.cgPointsListToStrokePointsList(cgPointList: self.drawingPoints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        switch self.currentShapeType {
            case ShapeType.Rectangle: drawRectangle(isSquare: false)
            
            case ShapeType.Triangle: drawTriangle(strokePointList: ShapeGenerator().getTrianglePoints(drawingPoints: CGStrokeConvertor.cgPointsListToStrokePointsList(cgPointList: drawingPoints)))
            
            case ShapeType.Circle: drawCircle()
            case ShapeType.Square: drawRectangle(isSquare: true)
        }
    }
    
    func drawRectangle(isSquare: Bool) {
        let rectangleWidth: CGFloat
        let rectangleHeight: CGFloat
        if isSquare{
            rectangleWidth = (permiterArray[0] + permiterArray[1]) / 2
            rectangleHeight = (permiterArray[0] + permiterArray[1]) / 2
            
        }else{
            rectangleHeight = permiterArray[0]
            rectangleWidth = permiterArray[1]
        }
        
        print("height: \(rectangleHeight)  width: \(rectangleWidth)")
        
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
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.beginPath()
        
        //6
        ctx.setLineWidth(3)
        
        let radius: CGFloat = permiterArray[0] / 2
        let endAngle: CGFloat = CGFloat(2 * Double.pi)
        
        ctx.addArc(center: self.centerPoint, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
        
        ctx.strokePath()
    }
    
    func drawTriangle(strokePointList: [StrokePoint]){
        let cgPointList = CGStrokeConvertor.strokePointsListToCGPointsList(strokePointList: strokePointList)
        let startPoint = cgPointList[0]
        let secondPoint = cgPointList[1]
        let lastPoint = cgPointList[2]
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.move(to: startPoint)
        ctx.addLine(to: secondPoint)
        ctx.addLine(to: lastPoint)
        ctx.fillPath()
    }
}
