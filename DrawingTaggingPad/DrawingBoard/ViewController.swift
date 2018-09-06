//
//  ViewController.swift
//  DrawingBoard
//
//   Created by py on 2018/9/6.
//  Copyright © 2018年 NJU.py. All rights reserved.

//

import UIKit

class ViewController: UIViewController {

    var brushes = [PencilBrush()]
    
    
    @IBOutlet var board: Board!
    @IBOutlet var topView: UIView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var undoButton: UIButton!
    @IBOutlet var redoButton: UIButton!
    
    var toolbarEditingItems: [UIBarButtonItem]?
    var currentSettingsView: UIView?
    
    @IBOutlet var topViewConstraintY: NSLayoutConstraint!
    @IBOutlet var toolbarConstraintBottom: NSLayoutConstraint!
    @IBOutlet var toolbarConstraintHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.board.brush = brushes[0]
        
        self.toolbarEditingItems = [
            UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "完成", style:.plain, target: self, action: #selector(ViewController.endSetting))
        ]
        self.toolbarItems = self.toolbar.items

        self.setupBrushSettingsView()
        self.setupBackgroundSettingsView()
        
        self.board.drawingStateChangedBlock = {(state: DrawingState) -> () in
            if state != .moved {
                UIView.beginAnimations(nil, context: nil)
                if state == .began {
                    self.topViewConstraintY.constant = -self.topView.frame.size.height
                    self.toolbarConstraintBottom.constant = -self.toolbar.frame.size.height
                    
                    self.topView.layoutIfNeeded()
                    self.toolbar.layoutIfNeeded()
                    
                    self.undoButton.alpha = 0
                    self.redoButton.alpha = 0
                } else if state == .ended {
                    UIView.setAnimationDelay(1.0)
                    self.topViewConstraintY.constant = 0
                    self.toolbarConstraintBottom.constant = 0
                    
                    self.topView.layoutIfNeeded()
                    self.toolbar.layoutIfNeeded()
                    
                    self.undoButton.alpha = 1
                    self.redoButton.alpha = 1
                }
                UIView.commitAnimations()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBrushSettingsView() {
        let brushSettingsView = UINib(nibName: "PaintingBrushSettingsView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! PaintingBrushSettingsView
        
        self.addConstraintsToToolbarForSettingsView(brushSettingsView)
        
        brushSettingsView.isHidden = true
        brushSettingsView.tag = 1
        brushSettingsView.backgroundColor = self.board.strokeColor
        
        brushSettingsView.strokeWidthChangedBlock = {
            [unowned self] (strokeWidth: CGFloat) -> Void in
            self.board.strokeWidth = strokeWidth
        }

        brushSettingsView.strokeColorChangedBlock = {
            [unowned self] (strokeColor: UIColor) -> Void in
            self.board.strokeColor = strokeColor
        }
    }
    
    func setupBackgroundSettingsView() {
        let backgroundSettingsVC = UINib(nibName: "BackgroundSettingsVC", bundle: nil).instantiate(withOwner: nil, options: nil).first as! BackgroundSettingsVC
        
        self.addConstraintsToToolbarForSettingsView(backgroundSettingsVC.view)
        
        backgroundSettingsVC.view.isHidden = true
        backgroundSettingsVC.view.tag = 2
        backgroundSettingsVC.setBackgroundColor(self.board.backgroundColor!)
        
        self.addChildViewController(backgroundSettingsVC)
        
        backgroundSettingsVC.backgroundImageChangedBlock = {
            [unowned self] (backgroundImage: UIImage) in
            self.board.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        
        backgroundSettingsVC.backgroundColorChangedBlock = {
            [unowned self] (backgroundColor: UIColor) in
            self.board.backgroundColor = backgroundColor
        }
    }
    
    func addConstraintsToToolbarForSettingsView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.toolbar.addSubview(view)
        self.toolbar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[settingsView]-0-|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: ["settingsView" : view]))
        self.toolbar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[settingsView(==height)]",
            options: NSLayoutFormatOptions(),
            metrics: ["height" : view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height],
            views: ["settingsView" : view]))
    }
    
    func updateToolbarForSettingsView() {
        self.toolbarConstraintHeight.constant = self.currentSettingsView!.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 44
        
        self.toolbar.setItems(self.toolbarEditingItems, animated: true)
        UIView.beginAnimations(nil, context: nil)
        self.toolbar.layoutIfNeeded()
        UIView.commitAnimations()
        
        self.toolbar.bringSubview(toFront: self.currentSettingsView!)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if let err = error {
            UIAlertView(title: "错误", message: err.localizedDescription, delegate: nil, cancelButtonTitle: "确定").show()
        } else {
            UIAlertView(title: "提示", message: "保存成功", delegate: nil, cancelButtonTitle: "确定").show()
        }
    }
    
    func clickTagBtn(_ sender: UIButton) {
        let alertController = UIAlertController.init(title: "提示", message: "标注成功", preferredStyle:.alert)
        let cancel = UIAlertAction.init(title: "好的", style: UIAlertActionStyle.cancel) { (action:UIAlertAction) ->() in
            print("处理完成\(action)")
            let frame = CGRect(x: 30, y: 30, width: 250, height: 100)
            let cgView = UIView(frame: frame)
            self.view.addSubview(cgView)
        }
        alertController.addAction(cancel);
        self.present(alertController, animated: true, completion: nil)
    }
    
    func clickInputBtn() {
        //初始化UITextField
        var inputText:UITextField = UITextField();
        let msgAlertCtr = UIAlertController.init(title: "提示", message: "请输入标注", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "确定", style:.default) { (action:UIAlertAction) ->() in
                print("你输入的是：\(String(describing: inputText.text))")
            
            let stringContent = inputText.text
            let magentaColor = UIColor.green
            let helveticaBold = UIFont.init(name: "HelveticaNeue-Bold", size: 30.0);
            stringContent?.draw(at: CGPoint(x: 20, y: 100), withAttributes:[NSFontAttributeName: helveticaBold!,  NSForegroundColorAttributeName: magentaColor])
            
        }
        
        let cancel = UIAlertAction.init(title: "取消", style:.cancel) { (action:UIAlertAction) -> ()in
            print("取消输入")
        }
        
        msgAlertCtr.addAction(ok)
        msgAlertCtr.addAction(cancel)
        //添加textField输入框
        msgAlertCtr.addTextField { (textField) in
            //设置传入的textField为初始化UITextField
            inputText = textField
            inputText.placeholder = "输入标注"
        }
        //设置到当前视图
        self.present(msgAlertCtr, animated: true, completion: nil)
    }



    @IBAction func switchBrush(_ sender: UISegmentedControl) {
        let functonCount = 0
        assert(sender.tag < self.brushes.count, "!!!")
        if(sender.selectedSegmentIndex <= functonCount){
            self.board.brush = self.brushes[sender.selectedSegmentIndex]
        }else{
          
        }
    }
    
    @IBAction func undo(_ sender: UIButton) {
        self.board.undo()
    }
    
    @IBAction func redo(_ sneder: UIButton) {
        self.board.redo()
    }
    
    @IBAction func paintingBrushSettings() {
        self.currentSettingsView = self.toolbar.viewWithTag(1)
        self.currentSettingsView?.isHidden = false
     
        self.updateToolbarForSettingsView()
    }

    @IBAction func backgroundSettings() {
        self.currentSettingsView = self.toolbar.viewWithTag(2)
        self.currentSettingsView?.isHidden = false
        
        self.updateToolbarForSettingsView()
    }
    
    @IBAction func saveToAlbum() {
        UIImageWriteToSavedPhotosAlbum(self.board.takeImage(), self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func endSetting() {
        self.toolbarConstraintHeight.constant = 44
        
        self.toolbar.setItems(self.toolbarItems, animated: true)
        
        UIView.beginAnimations(nil, context: nil)
        self.toolbar.layoutIfNeeded()
        UIView.commitAnimations()
        
        self.currentSettingsView?.isHidden = true
    }
}


