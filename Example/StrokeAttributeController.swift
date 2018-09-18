//
//  StrokeAttributeControllr.swift
//  DrawingTaggingPad
//
//  Created by py on 2018/9/14.
//  Copyright © 2018年 Yu Pan. All rights reserved.
//

import Foundation
import UIKit
import ChromaColorPicker

class StrokeAttributeController: UIViewController{
    
    @IBOutlet weak var colorDisplayView: UIView!
    var colorPicker: ChromaColorPicker!
    
    var viewController: ViewController?
    
    @IBAction func saveChange(_ sender: UIBarButtonItem) {
   
    }
    
    @IBOutlet var widthPicker: UIPickerView!
    
    
    let pickerData = [1, 2, 3, 4, 5, 6, 7, 8]
    
    
    override func viewDidLoad() {
        
        let pickerSize = CGSize(width: view.bounds.width*0.8, height: view.bounds.width*0.8)
        let pickerOrigin = CGPoint(x: view.bounds.midX - pickerSize.width/2, y: view.bounds.midY)
        
        /* Create Color Picker */
        colorPicker = ChromaColorPicker(frame: CGRect(origin: pickerOrigin, size: pickerSize))
        colorPicker.delegate = self
        
        /* Customize the view (optional) */
        colorPicker.padding = 10
        colorPicker.stroke = 3 //stroke of the rainbow circle
        colorPicker.currentAngle = Float.pi
        
        /* Customize for grayscale (optional) */
        colorPicker.supportsShadesOfGray = true // false by default
        colorPicker.hexLabel.textColor = UIColor.white
        
        self.view.addSubview(colorPicker)
    }
    
    override func didReceiveMemoryWarning() {
    }
    
    func getCurrentColor() -> [Int] {
        let colorString = colorPicker.hexLabel.text!.replacingOccurrences(of: "#", with: "")
        let redStr = colorString.substring(with: 0..<2)
        let greenStr = colorString.substring(with: 2..<4)
        let blueStr = colorString.substring(with: 4..<6)
        
        let redInt = Int(redStr, radix: 16)
        let greenInt = Int(greenStr, radix: 16)
        let blueInt = Int(blueStr, radix: 16)
        
        return [redInt!, greenInt!, blueInt!]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.destination is ViewController{
            let vc = segue.destination as? ViewController
            vc?.colorIntegerArray = getCurrentColor()
        }
    }
    
    
}

extension StrokeAttributeController: ChromaColorPickerDelegate{
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        //Set color for the display view
        colorDisplayView.backgroundColor = color
        
        //Perform zesty animation
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.colorDisplayView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { (done) in
            UIView.animate(withDuration: 0.2, animations: {
                self.colorDisplayView.transform = CGAffineTransform.identity
            })
        })
    }
    
}


extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

