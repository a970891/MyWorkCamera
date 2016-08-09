//
//  SystemWifiManager.swift
//  P2PCamera
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import SystemConfiguration.SCNetworkReachability

class SystemWifiManager: NSObject {

    /**
     获取ssid
     
     - returns: ssid
     */
    class func getSSID() ->String{
        if let interfaces: CFArrayRef = CNCopySupportedInterfaces(){
            let aa = unsafeBitCast(CFArrayGetValueAtIndex(interfaces, 0), CFString.self)
            if let myDic = CNCopyCurrentNetworkInfo(aa){
                if let dic = CFBridgingRetain(myDic){
                    return dic["SSID"] as! String
                }
            }
        }
        return ""
    }
    
}
