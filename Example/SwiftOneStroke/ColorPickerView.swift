//
//  ColorPickerView.swift
//  DrawingTaggingPad
//
//  Created by py on 2018/9/13.
//  Copyright © 2018年 Yu Pan. All rights reserved.
//

import UIKit
import ChromaColorPicker
import CoreGraphics

class ColorPickerView: UIView{
    
    var colorPicker: ChromaColorPicker!
    
    func initPicker(){
        let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        neatColorPicker.delegate = self as! ChromaColorPickerDelegate //ChromaColorPickerDelegate
        neatColorPicker.padding = 5
        neatColorPicker.stroke = 3
        neatColorPicker.hexLabel.textColor = UIColor.white

    }
    
    

}
