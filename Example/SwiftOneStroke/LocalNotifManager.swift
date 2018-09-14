//
//  LocalNotifManager.swift
//  PFReminder
//
//  Created by py on 2018/7/26.
//  Copyright © 2018年 cn.py. All rights reserved.
//
import UIKit
import UserNotifications
import CoreData

class LocalNotifManager: NSObject {
    let notification1 = "晚上时间体验一把图形画板"
    
    class func getRemindTimeWithString(remindTime : String, afterMinter : Int) -> String {
        let array = remindTime.components(separatedBy: ":")
        if array.count == 2 {
            var hour = Int(array[0]);
            var minter = Int(array[1]);
            var totalMinter = hour! * 60 + minter!
            totalMinter += afterMinter
            
            hour = Int(totalMinter / 60)
            minter = Int(totalMinter % 60)
            if minter! > 9 {
                return String(hour!) + ":" + String(minter!)
            }
            else {
                return String(hour!) + ":0" + String(minter!)
            }
        }
        
        return remindTime;
    }
    
    override init(){
        
        /* 通知的action，在通知到来下拉通知或者在通知栏长按通知会出现
         authenticationRequired: 需要解锁显示，黑色文字。点击会被登录拦截,解锁后也不会打开app
         destructive: 红色文字,点击不会进app
         foreground: 黑色文字,点击会进app
         */
        let lockAction = UNNotificationAction(identifier: "lock_action", title: "点击解锁", options: .authenticationRequired)
        let cancelAction = UNNotificationAction(identifier: "cancel_action", title: "点击消失", options: .destructive)
        let sureAction = UNNotificationAction(identifier: "sure_action", title: "点击进入app", options: .foreground)
        
        //设置一组通知类型，通过 local_notification 来标识
        let category = UNNotificationCategory(identifier: "local_notification", actions: [sureAction, lockAction, cancelAction], intentIdentifiers: [], options: .customDismissAction)
        
        //将该类型的通知加入到 通知中心
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    // 设置在 dateString 启动通知，每一分钟执行一次，共times次
    func setLocalNotification(aimDate: String, with dateString: String, times : Int, title: String, body: String) {
        //  print(title)
        // print(body)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        self.addNotiTemplate(aimDate: aimDate, dateString: dateString, sound: UNNotificationSound(named: "Reminder_to_wear_watch.m4a"), index: 0, times: times, week: 0, title: title, body: body)
    }
    
    /*
     新建提醒一次的通知
     */
    func addNotiTemplate(aimDate: String, dateString : String, sound : UNNotificationSound, index : Int, times : Int, week : Int, title: String, body: String) {
        
        if index >= times {
            return
        }
        
        let newDateString = LocalNotifManager.getRemindTimeWithString(remindTime: dateString, afterMinter: index)
        print(newDateString)
        let array0 = aimDate.components(separatedBy: "-")
        let array = newDateString.components(separatedBy: ":")
        let hour = Int(array[0]);
        let minute = Int(array[1]);
        let year = Int(array0[0])
        let month = Int(array0[1])
        let day = Int(array0[2])
        var component = DateComponents()
        component.year = year
        component.month = month
        component.day = day
        component.hour = hour
        component.minute = minute
        
        
        //通知有四种触发器:
        /*
         UNPushNotificationTrigger 触发APNS服务，系统自动设置（这是区分本地通知和远程通知的标识）
         UNTimeIntervalNotificationTrigger 一段时间后触发
         UNCalendarNotificationTrigger 指定日期触发
         UNLocationNotificationTrigger 根据位置触发，支持进入某地或者离开某地或者都有
         */
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: component, repeats: true)
        
        // 通知上下文，通过categoryIdentifier来唤起对应的 通知类型
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "local_notification"
        content.title = title
        content.body = body
        print(content.title)
        print(content.body)
        content.sound = sound
        
                let request = UNNotificationRequest(identifier: "request"+dateString+String(index), content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            print("week:\(String(describing: component.weekday)) hour:\(String(describing: component.hour)) minute:\(String(describing: component.minute)) index : \(index) success")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addNotifi(aimDate: aimDate, dateString: dateString, sound: sound, index: index+1, times: times, week: week, title: title, body: body)
        }
    }
    
    
    
    /*
     做测试的新建通知，尚可
     */
    func addNotifi(aimDate: String, dateString : String, sound : UNNotificationSound, index : Int, times : Int, week : Int, title: String, body: String) {
        
        if index >= times {
            return
        }
        
        let newDateString = LocalNotifManager.getRemindTimeWithString(remindTime: dateString, afterMinter: index)
        print(newDateString)
        let array0 = aimDate.components(separatedBy: "-")
        let array = newDateString.components(separatedBy: ":")
        let hour = Int(array[0]);
        let minute = Int(array[1]);
        let year = Int(array0[0])
        let month = Int(array0[1])
        let day = Int(array0[2])
        var component = DateComponents()
        component.year = year
        component.month = month
        component.day = day
        component.hour = hour
        component.minute = minute
        
        //通知有四种触发器:
        /*
         UNPushNotificationTrigger 触发APNS服务，系统自动设置（这是区分本地通知和远程通知的标识）
         UNTimeIntervalNotificationTrigger 一段时间后触发
         UNCalendarNotificationTrigger 指定日期触发
         UNLocationNotificationTrigger 根据位置触发，支持进入某地或者离开某地或者都有
         */
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: component, repeats: true)
        
        // 通知上下文，通过categoryIdentifier来唤起对应的 通知类型
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "local_notification"
        content.title = title
        content.body = body
        content.sound = sound
        
       
        let request = UNNotificationRequest(identifier: "request"+dateString+String(index), content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            print("week:\(String(describing: component.weekday)) hour:\(String(describing: component.hour)) minute:\(String(describing: component.minute)) index : \(index) success")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addNotifi(aimDate: aimDate, dateString: dateString, sound: sound, index: index+1, times: times, week: week, title: title, body: body)
        }
    }
    
    
    /*
     用户内置的自带通知
     */
    
    
    func setInnerNotification(){
        let currentDate = DateUtil().getCurrentYMD()
        setLocalNotification(aimDate: currentDate, with: "23:09", times: 1, title: "智能画板", body: notification1)
    }
        
        
    
    /*
     删除用户修改的原有通知，参数title, body
     */
    
    func removeNotif(title: String, body: String) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests : [UNNotificationRequest]) in
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("删除所有通知")
            
            for request in requests {
                let requestTitle = request.content.title
                let requestBody = request.content.body
                
                if title != requestTitle || body != requestBody{
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                    })
                }else{
                    print("删除成功")
                }
            }
        })
    }
    
}
