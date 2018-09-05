//
//  Board.swift
//  DrawingTaggingPad
//
//  Created by py on 2018/9/4.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit
import CoreGraphics

enum state{
    case Begin, End, Move
}

class Board: UIImageView{
    var strokeWidth: CGFloat = 0.0
    var strokeColor: UIColor
    var shape: Shape?
    
    
    private var currentState: state!
    private var realImage: UIImage!
    
    
    override init(frame: CGRect) {
        self.currentState = state.Begin
        self.strokeWidth = 1
        self.strokeColor = UIColor.black
        super.init(frame: <#T##CGRect#>)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
       //Event that begin to touch and move
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let shape = self.shape {
            shape.lastPoint = nil
            
            shape.beginPoint = touches.first!.location(in: self)
            shape.endPoint = shape.beginPoint
            
            self.currentState = state.Begin
            
            self.drawingImage()
        }
    }
    
    
    override func touchesMoved(_ touches:Set<UITouch>, with event: UIEvent?) {
        if let shape = self.shape {
            shape.endPoint = touches.first!.location(in: self)
            
            self.currentState = state.Move
            
            self.drawingImage()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        if let shape = self.shape {
            shape.endPoint = nil
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.shape {
            brush.endPoint = touches.first!.location(in: self)
            
            self.currentState = state.End
            
            self.drawingImage()
        }
    }
    
    private func drawingImage() {
        if let brush = self.shape {
            
            // 1.
            UIGraphicsBeginImageContext(self.bounds.size)
            
            let context = UIGraphicsGetCurrentContext()
            
            UIColor.clear.setFill()
            UIRectFill(self.bounds)
            
            context!.setLineWidth(self.strokeWidth)
            context!.setStrokeColor(self.strokeColor.cgColor)
            
            if let realImage = self.realImage {
                realImage.draw(in: self.bounds)
            }
            
            brush.strokeWidth = self.strokeWidth
            brush.drawInContext(context: context!);
            context!.strokePath()
            
            // 5.
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.currentState == state.End || (shape?.supportedContinuousDrawing())! {
                self.realImage = previewImage
            }
            
            UIGraphicsEndImageContext()
            
            // 6.
            self.image = previewImage;
            
            brush.lastPoint = brush.endPoint
        }
    }
        
}






