//
//  ActionManager.swift
//  P2PCamera
//
//  Created by 易风 on 16/9/11.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit

class ActionManager: NSObject {

    class func getObjects() -> [ActionObject] {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("actions"){
            if let arr  = NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as? [ActionObject] {
                return arr
            }
        }
        return [ActionObject]()
    }
    
    class func insertAction(action:String, uid:String, name:String) {
        var objects = ActionManager.getObjects()
        for i in 0 ..< objects.count {
            if objects[i].uid == uid {
                objects[i].actions[String(NSDate().timeIntervalSince1970)] = action
                NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(objects), forKey: "actions")
                NSUserDefaults.standardUserDefaults().synchronize()
                return
            }
        }
        let object = ActionObject()
        object.name = name
        object.uid = uid
        object.actions[String(NSDate().timeIntervalSince1970)] = action
        objects.append(object)
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(objects), forKey: "actions")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
}
