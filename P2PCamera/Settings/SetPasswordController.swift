//
//  SetPasswordController.swift
//  P2PCamera
//
//  Created by lu on 16/8/23.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit

class SetPasswordController: UITableViewController {
    
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPassword2: UITextField!
    
    var cameraObj:CameraObject!
    var tutkManager:TutkP2PAVClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    @IBAction func savaAction2(sender: AnyObject) {
        if let p1 = oldPassword.text, p2 = newPassword.text, p3 = newPassword2.text {
            if p1.characters.count != 0 && p2.characters.count != 0 && p3.characters.count != 0 {
                if p1 != cameraObj.password {
                    UIAlertView(title: "提示", message: "旧密码错误", delegate: self, cancelButtonTitle: "好").show()
                    return;
                }
                if p2 != p3 {
                    UIAlertView(title: "提示", message: "两次输入的密码不一致", delegate: self, cancelButtonTitle: "好").show()
                    return;
                }
                if tutkManager.setPassword(p1, p2) != -1 {
                    cameraObj.password = p2
                    tutkManager.connect(cameraObj.uid, cameraObj.password)
                    CameraManager.sharedInstance().insertObject(cameraObj)
                    SVProgressHUD.showSuccessWithStatus("修改成功")
                } else {
                    SVProgressHUD.showErrorWithStatus("修改失败")
                }
                return;
            }
        }
        UIAlertView(title: "提示", message: "密码不能为空", delegate: self, cancelButtonTitle: "好").show()
    }
}
