//
//  UIAlertController.swift
//  DrawingTaggingPad
//  Extend the alert textfield
//
//  Created by py on 2018/9/6.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

class UITextFieldController: UIViewController,UITextFieldDelegate {
    
    func clickTagBtn(_ sender: UIButton) {
        let alertController = UIAlertController.init(title: "提示", message: "标注成功", preferredStyle:.alert)
        let cancel = UIAlertAction.init(title: "好的", style: UIAlertActionStyle.cancel) { (action:UIAlertAction) ->() in
            print("处理完成\(action)")
        }
        alertController.addAction(cancel);
        self.present(alertController, animated: true, completion: nil)
    }
    
    func clickInputBtn(_ sender: UIButton) {
        //初始化UITextField
        var inputText:UITextField = UITextField();
        let msgAlertCtr = UIAlertController.init(title: "提示", message: "请输入标注", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "确定", style:.default) { (action:UIAlertAction) ->() in
            if((inputText.text) == ""){
                print("你输入的是：\(String(describing: inputText.text))")
                
            }
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

}
