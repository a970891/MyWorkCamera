//
//  EditCameraTableViewController.swift
//  SetView
//
//  Created by 花早 on 16/5/24.
//  Copyright © 2016年 花早. All rights reserved.
//

import UIKit

class EditCameraTableViewController: UITableViewController {
    
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
        tutkManager = TutkP2PAVClient()
        let a = tutkManager.connect(cameraObj.uid, cameraObj.password)
        if a != -1 {
            tutkManager.getVideoMode()
            tutkManager.getEnvironmentMode()
            tutkManager.getMotionDetect()
            tutkManager.getDeviceInfo()
            tutkManager.getVideoQuality()
            
            /*
             //获取显示模式
             -(int)getVideoMode;
             //获取环境模式
             -(int)getEnvironmentMode;
             //获取移动侦测
             -(int)getMotionDetect;
             //获取录像模式
             -(int)getRecordMode;
             //格式化SD卡
             -(int)getStorage;
             //获取视频质量
             -(int)getVideoQuality;
             */
        }
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

}
