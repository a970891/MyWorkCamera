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
    
    private var tutkManager:TutkP2PAVClient!
    
    var cameraObj:CameraObject!
    
    lazy var tableViewHead:EditCameraHead = {
        let v = NSBundle.mainBundle().loadNibNamed("EditCameraHead", owner: self, options: nil).first as! EditCameraHead
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutkManager = TutkP2PAVClient()
        tutkManager.infoDelegate = self;
        self.tableView.tableHeaderView = self.tableViewHead
        self.tableViewHead.TitleLabel.text = cameraObj.uid
        self.nameField.text = cameraObj.name
        self.passwordField.text = cameraObj.password
        self.getCameraInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    
    func getCameraInfo() {
        let a = tutkManager.connect(cameraObj.uid, cameraObj.password)
        if a != -1 {
            tutkManager.getVideoMode()
            tutkManager.getEnvironmentMode()
            tutkManager.getMotionDetect()
            tutkManager.getDeviceInfo()
            tutkManager.getVideoQuality()
            tutkManager.getRecordMode()
        }
    }
    
    //Mark************* cameraInfoDelegate *************
    //收到wifi信息回调
    func receiveWifi() {
        
    }
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let vc = segue.destinationViewController
        if vc.classForCoder == SetTableViewController.classForCoder() {
            (vc as! SetTableViewController).cameraObj = self.cameraObj
            (vc as! SetTableViewController).tutkManager = self.tutkManager
        }
    }
    
}
