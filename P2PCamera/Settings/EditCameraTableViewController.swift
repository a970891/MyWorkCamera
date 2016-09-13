//
//  EditCameraTableViewController.swift
//  SetView
//
//  Created by 花早 on 16/5/24.
//  Copyright © 2016年 花早. All rights reserved.
//

import UIKit

class EditCameraTableViewController: UITableViewController,CameraInfoDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pushSwitch: UISwitch!
    
    private var firstShow:Int = 1
    
    private var tutkManager:TutkP2PAVClient!
    private var wifis = [wifiObject]()
    
    var cameraObj:CameraObject!
    
    lazy var tableViewHead:EditCameraHead = {
        let v = NSBundle.mainBundle().loadNibNamed("EditCameraHead", owner: self, options: nil).first as! EditCameraHead
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = Myself.sharedInstance().findUID(self.cameraObj.uid) ? "已联机" : "未联机"
        tutkManager = cameraObj.tutkManager;
        tutkManager.infoDelegate = self;
        self.tableView.tableHeaderView = self.tableViewHead
        self.tableViewHead.TitleLabel.text = cameraObj.uid
        self.nameField.text = cameraObj.name
        self.passwordField.text = cameraObj.password
        self.passwordField.enabled = true
        self.pushSwitch.on = !(self.cameraObj.push == "0")
        pushSwitch.addTarget(self, action: #selector(EditCameraTableViewController.modifedPushSet(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstShow == 1 {
            firstShow = 0
            self.getCameraInfo()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    
    func getCameraInfo() {
        statusLabel.text = "连接中"
        tutkManager.connectsuccess({
            self.tutkManager.listWifiAp()
            self.tutkManager.getVideoMode()
            self.tutkManager.getEnvironmentMode()
            self.tutkManager.getMotionDetect()
            self.tutkManager.getDeviceInfo()
            self.tutkManager.getVideoQuality()
            self.tutkManager.getRecordMode()
            self.statusLabel.text = "已联机"
            }, fail: {
                self.statusLabel.text = "未联机"
        })
    }
    
    func modifedPushSet(pushSwitch:UISwitch) {
        self.cameraObj.push = pushSwitch.on ? "1" : "0"
        CameraManager.sharedInstance().insertObject(self.cameraObj)
    }
    
    //Mark************* cameraInfoDelegate *************
    //收到视频模式回调
    func receiveVideoMode(mode: Int32) {
        self.cameraObj.videoMode = NSNumber(int: mode)
    }
    //收到视频质量回调
    func receiveQuality(quality: Int32) {
        self.cameraObj.quality = NSNumber(int: quality)
    }
    //收到移动侦测回调
    func receiveMotionDetect(detect: Int32) {
        self.cameraObj.motionDetect = NSNumber(int: detect)
    }
    //收到环境模式回调
    func receiveEnvironmentMode(mode: Int32) {
        self.cameraObj.placeMode = NSNumber(int: mode)
    }
    //收到SD卡格式化回调
    func receiveEXTSdCardResult(result: Int32) {
        switch result {
        case 0:
            //成功
            SVProgressHUD.showErrorWithStatus("格式化成功")
            break;
        default:
            //失败
            SVProgressHUD.showErrorWithStatus("格式化失败")
            break;
        }
    }
    //收到设备信息回调
    func receiveDeviceInfo(type: Int32, content: String!) {
        switch type {
        case 0:
            self.cameraObj.model = content
        case 1:
            self.cameraObj.firm = content
        case 2:
            self.cameraObj.cameraVersion = content
        case 3:
            self.cameraObj.rom = NSNumber(int:(content as NSString).intValue)
        case 4:
            self.cameraObj.reduceRom = NSNumber(int:(content as NSString).intValue)
        default:
            break;
        }
    }
    //收到ssid和mode回调
    func receiveWifi(ssids: [AnyObject]!, modes: [AnyObject]!, types: [AnyObject]!) {
        for i in 0 ..< ssids.count {
            let wifi = wifiObject()
            wifi.ssid = ssids[i] as! String
            wifi.mode = modes[i] as! String
            wifi.type = types[i] as! String
            self.wifis.append(wifi)
            print(wifi.ssid)
        }
    }
    //收到录像模式回调
    func receiveRecordType(type: Int32) {
        self.cameraObj.recordMode = NSNumber(int: type)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        
        if let pwd = self.passwordField.text {
            if let name = self.nameField.text {
                if (pwd as NSString).length != 0 && (name as NSString).length != 0 {
                    self.cameraObj.password = pwd
                    self.cameraObj.name = name
                    CameraManager.sharedInstance().insertObject(cameraObj)
                    return;
                }
            }
        }
        UIAlertView(title: "提示", message: "名字或密码不能为空", delegate: self, cancelButtonTitle: "好").show()
    }

//    deinit {
//        tutkManager.closeSession()
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if statusLabel.text == "已联机" {
                
            } else {
                //只有已联机才允许跳转
                return;
            }
            let vc = self.StoryboardWithIdentifier("Settings", Identifier: "the") as! SetTableViewController
            vc.cameraObj = self.cameraObj
            vc.tutkManager = self.tutkManager
            vc.wifis = self.wifis
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 2 {
            if statusLabel.text == "未联机" {
                self.getCameraInfo()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let vc = segue.destinationViewController
        if vc.classForCoder == SetTableViewController.classForCoder() {
            (vc as! SetTableViewController).cameraObj = self.cameraObj
            (vc as! SetTableViewController).tutkManager = self.tutkManager
            (vc as! SetTableViewController).wifis = self.wifis
        }
    }
    
}

class wifiObject:NSObject {
    dynamic var ssid:String = ""
    dynamic var mode:String = ""
    dynamic var type:String = ""
}
