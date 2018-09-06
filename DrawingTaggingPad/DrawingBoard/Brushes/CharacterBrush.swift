//
//  CharacterBrush.swift
//  DrawingTaggingPad
//
//  Created by py on 2018/9/6.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

class CharacterBrush {
    func drawText(_ context: CGContext) {
        let str = "test"
        let rect = CGRect(x: 300, y: 300, width: 280, height: 200)
        let font = UIFont.systemFont(ofSize: 16)
        let color = UIColor.red
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        (str as NSString).draw(in: rect, withAttributes: [NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:style])
    
    }

}
