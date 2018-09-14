//
//  DateUtil.swift
//  PFReminder
//
//  Created by py on 2018/7/26.
//  Copyright © 2018年 cn.py. All rights reserved.
//
import Foundation

class DateUtil: NSObject{
    func getCurentDate() -> String{
        let nowDate = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: nowDate as Date)
        print(dateString)
        return dateString
    }
    
    func getCurrentYMD() -> String{
        let nowDate = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: nowDate as Date)
        print(dateString)
        return dateString
    }
}
