//
//  EraserBrush.swift
//  DrawingBoard
//
//  Created by py on 2018/9/3.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

class EraserBrush: PencilBrush {
    
    override func drawInContext(_ context: CGContext) {
        context.setBlendMode(CGBlendMode.clear)
        
        super.drawInContext(context)
    }
}
