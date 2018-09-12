//
//  Board.swift
//  DrawingBoard
//
//   Created by py on 2018/9/3.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

enum DrawingState {
    case began, moved, ended
}

class Board: UIImageView {


    // UndoManager，用于实现 Undo 操作和维护图片栈的内存
    fileprivate class DBUndoManager {
        class DBImageFault: UIImage {}  // 一个 Fault 对象，与 Core Data 中的 Fault 设计类似
        
        fileprivate static let INVALID_INDEX = -1
        fileprivate var images = [UIImage]()    // 图片栈
        fileprivate var index = INVALID_INDEX   // 一个指针，指向 images 中的某一张图

        var canUndo: Bool {
            get {
                return index != DBUndoManager.INVALID_INDEX
            }
        }
        
        var canRedo: Bool {
            get {
                return index + 1 < images.count
            }
        }

        func addImage(_ image: UIImage) {
            // 当往这个 Manager 中增加图片的时候，先把指针后面的图片全部清掉，
            // 这与我们之前在 drawingImage 方法中对 redoImages 的处理是一样的
            if index < images.count - 1 {
                images[index + 1 ... images.count - 1] = []
            }
            
            images.append(image)
            
            // 更新 index 的指向
            index = images.count - 1
            
            setNeedsCache()
        }
        
        func imageForUndo() -> UIImage? {
            if self.canUndo {
                index -= 1
                if self.canUndo == false {
                    return nil
                } else {
                    setNeedsCache()
                    return images[index]
                }
            } else {
                return nil
            }
        }
        
        func imageForRedo() -> UIImage? {
            var image: UIImage? = nil
            if self.canRedo {
                index += 1
                image = images[index]
            }
            setNeedsCache()
            return image
        }
        
        // MARK: - Cache
        
        fileprivate static let cahcesLength = 3 // 在内存中保存图片的张数，以 index 为中心点计算：cahcesLength * 2 + 1
        fileprivate func setNeedsCache() {
            if images.count >= DBUndoManager.cahcesLength {
                let location = max(0, index - DBUndoManager.cahcesLength)
                let length = min(images.count - 1, index + DBUndoManager.cahcesLength)
                for i in location ... length {
                    autoreleasepool {
                        let image = images[i]
                        
                        if i > index - DBUndoManager.cahcesLength && i < index + DBUndoManager.cahcesLength {
                            setRealImage(image, forIndex: i) // 如果在缓存区域中，则从文件加载
                        } else {
                            setFaultImage(image, forIndex: i) // 如果不在缓存区域中，则置成 Fault 对象
                        }
                    }
                }
            }
        }

        fileprivate static var basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        fileprivate func setFaultImage(_ image: UIImage, forIndex: Int) {
            if !image.isKind(of: DBImageFault.self) {
                let imagePath = (DBUndoManager.basePath as NSString).appendingPathComponent("\(forIndex)")
                try? UIImagePNGRepresentation(image)!.write(to: URL(fileURLWithPath: imagePath), options: [])
                images[forIndex] = DBImageFault()
            }
        }
        
        fileprivate func setRealImage(_ image: UIImage, forIndex: Int) {
            if image.isKind(of: DBImageFault.self) {
                let imagePath = (DBUndoManager.basePath as NSString).appendingPathComponent("\(forIndex)")
                images[forIndex] = UIImage(data: try! Data(contentsOf: URL(fileURLWithPath: imagePath)))!
            }
        }
    }
    
    var brush: BaseBrush?
    
    var strokeWidth: CGFloat
    var strokeColor: UIColor
    
    var drawingStateChangedBlock: ((_ state: DrawingState) -> ())?
    
    var drawingPoints = [StrokePoint]()
    
    fileprivate var realImage: UIImage?
    fileprivate var boardUndoManager = DBUndoManager() // 缓存或Undo控制器
    
    fileprivate var drawingState: DrawingState!
    
    override init(frame: CGRect) {
        self.strokeColor = UIColor.black
        self.strokeWidth = 1
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.strokeColor = UIColor.black
        self.strokeWidth = 1
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public methods
    
    var canUndo: Bool {
        get {
            return self.boardUndoManager.canUndo
        }
    }
    
    var canRedo: Bool {
        get {
            return self.boardUndoManager.canRedo
        }
    }
    
    // undo 和 redo 的逻辑都有所简化
    func undo() {
        if self.canUndo == false {
            return
        }
        
        self.image = self.boardUndoManager.imageForUndo()
        
        self.realImage = self.image
    }
    
    func redo() {
        if self.canRedo == false {
            return
        }

        self.image = self.boardUndoManager.imageForRedo()
            
        self.realImage = self.image
    }
    
    func takeImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        
        self.backgroundColor?.setFill()
        UIRectFill(self.bounds)
        
        self.image?.draw(in: self.bounds)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    // MARK: - touches methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.lastPoint = nil
            
            brush.beginPoint = touches.first!.location(in: self)
            brush.endPoint = brush.beginPoint
			print(brush.beginPoint)
            self.drawingState = .began
            self.drawingPoints.removeAll()
            self.drawingImage()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.first!.location(in: self)
            let point = touches.first!.location(in: self)
            if !containPoint(point: StrokePoint(x: Double(point.x), y: Double(point.y))){
                drawingPoints.append(StrokePoint(point: point))
            }
            
            self.drawingState = .moved
         //   print(brush.endPoint)
            self.drawingImage()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.first!.location(in: self)
            let point = touches.first!.location(in: self)
            if !containPoint(point: StrokePoint(x: Double(point.x), y: Double(point.y))){
                drawingPoints.append(StrokePoint(point: point))
            }
            self.drawingState = .ended
            
            self.drawingImage()
        }
    }
    
    // MARK: - drawing
    
    fileprivate func drawingImage() {
        if let brush = self.brush {
            // hook
            if let drawingStateChangedBlock = self.drawingStateChangedBlock {
                drawingStateChangedBlock(self.drawingState)
            }

            UIGraphicsBeginImageContext(self.bounds.size)
            
            let context = UIGraphicsGetCurrentContext()
            
            UIColor.clear.setFill()
            UIRectFill(self.bounds)
            
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(self.strokeWidth)
            context?.setStrokeColor(self.strokeColor.cgColor)
            
            if let realImage = self.realImage {
                realImage.draw(in: self.bounds)
            }
            
            brush.strokeWidth = self.strokeWidth
            brush.drawInContext(context!)
            context?.strokePath()
            
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.drawingState == .ended || brush.supportedContinuousDrawing() {
                self.realImage = previewImage
            }
            
            UIGraphicsEndImageContext()
            
            // 用 Ended 事件代替原先的 Began 事件
            if self.drawingState == .ended {
                self.boardUndoManager.addImage(self.image!)
            }
            
            self.image = previewImage
            
            brush.lastPoint = brush.endPoint
        }
    }
    
    func containPoint(point: StrokePoint) -> Bool{
        for ordinaryPoint in self.drawingPoints{
            if ordinaryPoint.x == point.x && ordinaryPoint.y == point.y{
                return true
            }
        }
        return false
    }
}
