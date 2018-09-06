//
//  BackgroundSettingsView.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-3-29.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class BackgroundSettingsVC : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var backgroundImageChangedBlock: ((_ backgroundImage: UIImage) -> Void)?
    var backgroundColorChangedBlock: ((_ backgroundColor: UIColor) -> Void)?
    
    @IBOutlet fileprivate var colorPicker: RGBColorPicker!
    
    lazy fileprivate var pickerController: UIImagePickerController = {
        [unowned self] in
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        return pickerController
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.colorPicker.colorChangedBlock = {
            [unowned self] (color: UIColor) in
            if let backgroundColorChangedBlock = self.backgroundColorChangedBlock {
                backgroundColorChangedBlock(color)
            }
        }
    }
    
    func setBackgroundColor(_ color: UIColor) {
        self.colorPicker.setCurrentColor(color)
    }
    
    @IBAction func pickImage() {
        self.present(self.pickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if let backgroundImageChangedBlock = self.backgroundImageChangedBlock {
            backgroundImageChangedBlock(image)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UINavigationControllerDelegate Methods
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UIApplication.shared.setStatusBarHidden(true, with: .none)
    }
}
