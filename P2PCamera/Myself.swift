//
//  Myself.swift
//  P2PCamera
//
//  Created by mac on 16/9/7.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit

class Myself: NSObject {
    
    static private var myself:Myself = Myself()
    private var nowConnectCamera = [String]()
    private var nowTutkManagers = [String:TutkP2PAVClient]()
    private var nowCameras = [String:String]()
    var language:Bool!
    var s_avIndex:Int = -1
    
    override init() {
        super.init()
        let languages = NSLocale.preferredLanguages()
        if languages[0] == "en-US" {
            self.language = true;
        } else {
            self.language = false;
        }
    }
    
    class func sharedInstance() -> Myself {
        return self.myself;
    }
    
    /**
     获取本机语言(英文true,中文false)
     */
    class func getCurrentLanguage() -> Bool{
        return self.sharedInstance().language
    }
    
    /**
     初始化tutk组件
     */
    class func initTutkManager(succeed:(() -> Void), failed:(() -> Void)){
        dispatch_async(dispatch_get_global_queue(0, 0)) { 
            if TutkP2PAVClient.initializeTutk() != -1 {
                dispatch_async(dispatch_get_main_queue(), {
                    succeed()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    failed()
                })
            }
        }
    }
    
    /**
     寻找设备是否已连接
     */
    func findUID(uid:String) ->Bool {
        return self.nowConnectCamera.contains(uid)
    }
    
    /**
     在已连接设备中插入对应UID
     */
    func insertUID(uid:String) {
        if self.findUID(uid) {
            return
        } else {
            self.nowConnectCamera.append(uid)
        }
    }
    
    /**
     在已连接设备中删除对应UID
     */
    func deleteUID(uid:String) {
        if self.findUID(uid) {
            for i in 0 ..< self.nowConnectCamera.count {
                if uid == self.nowConnectCamera[i] {
                    self.nowConnectCamera.removeAtIndex(i)
                }
            }
        }
    }
    
    /**
     根据uid搜索对应的tutkmanager
     */
    func findManagerWithUID(uid:String) -> TutkP2PAVClient{
        if let manager = self.nowTutkManagers[uid] {
            return manager
        } else {
            let manager = TutkP2PAVClient()
            self.nowTutkManagers[uid] = manager
            return manager
        }
    }
    
    /**
     根据UID插入摄像头连接状态
     */
    func insertCameraWithStatus(uid:String,status:Int) {
        //摄像头已存在记录
        for i in 0 ..< self.nowCameras.keys.count {
            let key = (self.nowCameras as NSDictionary).allKeys[i] as! String
            if key == uid {
                self.nowCameras[key] = String(status)
                return
            }
        }
        //未存在记录
        self.nowCameras[uid] = "0"
    }
    
    /**
     根据UID获取摄像头连接状态
     */
    func findStatusWithUid(uid:String) -> String {
        //摄像头已存在记录
        for i in 0 ..< self.nowCameras.keys.count {
            let key = (self.nowCameras as NSDictionary).allKeys[i] as! String
            if key == uid {
                return self.nowCameras[key]!
            }
        }
        //未存在记录
        return "0"
    }
    
}
