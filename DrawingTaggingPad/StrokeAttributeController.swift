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

class StrokeAttributeController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var colorDisplayView: UIView!
    var colorPicker: ChromaColorPicker!
    
    var viewController: ViewController?
    
    @IBAction func saveChange(_ sender: UIBarButtonItem) {
        
    }
    
    @IBOutlet var widthPicker: UIPickerView!
    
    
    let pickerData = ["极细", "细", "普通", "较粗", "粗", "极粗"]
    
    
    override func viewDidLoad() {
        widthPicker.dataSource = self
        widthPicker.delegate = self
        
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
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.destination is ViewController{
            let vc = segue.destination as? ViewController
            vc?.colorIntegerArray = getCurrentColor()
            let selectedValue = pickerData[widthPicker.selectedRow(inComponent: 0)]
            print("val: \(selectedValue)")
            vc?.strokeWidth = strokeWidthConvertor(strokeDescription: selectedValue)
        }
    }
    
    func strokeWidthConvertor(strokeDescription: String) -> Int {
        switch strokeDescription {
        case "极细":
            return 2
        case "细":
            return 3
        case "普通":
            return 4
        case "较粗":
            return 5
        case "粗":
            return 6
        case "极粗":
            return 7
        default:
            return 4
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
