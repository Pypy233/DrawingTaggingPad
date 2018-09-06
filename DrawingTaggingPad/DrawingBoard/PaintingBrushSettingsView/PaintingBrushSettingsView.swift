//
//  PaintingBrushSettingsView.swift
//  DrawingBoard
//
//   Created by py on 2018/9/6.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

class PaintingBrushSettingsView : UIView {
    
    var strokeWidthChangedBlock: ((_ strokeWidth: CGFloat) -> Void)?
    var strokeColorChangedBlock: ((_ strokeColor: UIColor) -> Void)?
    
    @IBOutlet fileprivate var strokeWidthSlider: UISlider!
    @IBOutlet fileprivate var strokeColorPreview: UIView!
    @IBOutlet fileprivate var colorPicker: RGBColorPicker!
    
    override var backgroundColor: UIColor? {
        didSet {
            self.strokeColorPreview.backgroundColor = self.backgroundColor
            self.colorPicker.setCurrentColor(self.backgroundColor!)
            
            super.backgroundColor = oldValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.strokeColorPreview.layer.borderColor = UIColor.black.cgColor
        self.strokeColorPreview.layer.borderWidth = 1
        
        self.colorPicker.colorChangedBlock = {
            [unowned self] (color: UIColor) in
            
            self.strokeColorPreview.backgroundColor = color
            if let strokeColorChangedBlock = self.strokeColorChangedBlock {
                strokeColorChangedBlock(color)
            }
        }
        
        self.strokeWidthSlider.addTarget(self, action: #selector(PaintingBrushSettingsView.strokeWidthChanged(_:)), for:.valueChanged)
    }
    
    func strokeWidthChanged(_ slider: UISlider) {
        if let strokeWidthChangedBlock = self.strokeWidthChangedBlock {
            strokeWidthChangedBlock(CGFloat(slider.value))
        }
    }
}
