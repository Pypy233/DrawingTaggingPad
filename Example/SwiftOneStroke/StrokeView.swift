//
//  StrokeView.swift
//  SwiftOneStroke
//
//  Created by py on 2018/9/11.
//  Copyright © 2018年 Yu Pan. All rights reserved.
//

import UIKit

typealias StrokeViewEndBlock = (_ points: [StrokePoint]?) -> (Void)

open class StrokeView : UIView {
	
	var drawPath: UIBezierPath
	var onDidFinishDrawing: StrokeViewEndBlock?
	var activePoints = [StrokePoint]()
    var strokeColor =  UIColor.black
	
    override init(frame: CGRect) {
		drawPath = UIBezierPath()
		super.init(frame: frame)
		self.backgroundColor = UIColor.lightGray
	}

	required public init?(coder aDecoder: NSCoder) {
		drawPath = UIBezierPath()
		super.init(coder: aDecoder)
	}
	
	open func loadPath(_ points: [StrokePoint]) {
		self.drawPath = UIBezierPath()
		if points.count > 0 {
			self.drawPath.move(to: points.first!.toPoint())
			for i in 1...points.count {
				self.drawPath.addLine(to: points[i].toPoint())
			}
			self.setNeedsDisplay()
		}
	}
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.drawPath = UIBezierPath()
		self.drawPath.lineWidth = 3.0
		activePoints.removeAll()
		let point = touches.first!.location(in: self)
		self.drawPath.move(to: point)
		activePoints.append(StrokePoint(point: point))
		
		self.setNeedsDisplay()
	}
	
	open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let point = touches.first!.location(in: self)
		self.drawPath.addLine(to: point)
		activePoints.append(StrokePoint(point: point))

		self.setNeedsDisplay()
	}
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let point = touches.first!.location(in: self)
		self.drawPath.move(to: point)
		activePoints.append(StrokePoint(point: point))
		self.setNeedsDisplay()
		onDidFinishDrawing?(activePoints)
	}
	
	open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		if touches != nil {
			self.touchesEnded(touches, with: event)
		}
	}

	open override func draw(_ rect: CGRect) {
		let ctx = UIGraphicsGetCurrentContext()
		ctx?.setLineWidth(3.0)
        //
     //   let color = UIColor(rgb: 0xFF6800)
       // color.setStroke()
        strokeColor.setStroke()
        ctx?.addPath(self.drawPath.cgPath)
		ctx?.strokePath()
	}
    
    open func setStrokeColor(color: UIColor) {
        color.setStroke()
    }
    
    
}

