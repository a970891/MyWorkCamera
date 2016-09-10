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
    var tutkManager:TutkP2PAVClient!
    var nowConnectCamera:String = ""
    var language:Bool!
    var m_avIndex:Int = -1
    var s_avIndex:Int = -1
    var SID:Int = 0
    
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
                    self.sharedInstance().tutkManager = TutkP2PAVClient()
                    succeed()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    failed()
                })
            }
        }
    }
    
}
