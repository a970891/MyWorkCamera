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

        self.showNaviBackButton()
    }

    @IBAction func savaAction2(sender: AnyObject) {
        if let p1 = oldPassword.text, p2 = newPassword.text, p3 = newPassword2.text {
            if p1.characters.count != 0 && p2.characters.count != 0 && p3.characters.count != 0 {
                if p1 != cameraObj.password {
                    UIAlertView(title: NSLocalizedString("A_title", comment:""), message: NSLocalizedString("S_oldWrong", comment:""), delegate: self, cancelButtonTitle: NSLocalizedString("A_sure", comment:"")).show()
                    return;
                }
                if p2 != p3 {
                    UIAlertView(title: NSLocalizedString("A_title", comment:""), message: NSLocalizedString("S_twiceWrong", comment:""), delegate: self, cancelButtonTitle: NSLocalizedString("A_sure", comment:"")).show()
                    return;
                }
                if tutkManager.setPassword(p1, p2) != -1 {
                    cameraObj.password = p2
                    CameraManager.sharedInstance().insertObject(cameraObj)
                    SVProgressHUD.showSuccessWithStatus(NSLocalizedString("S_changeSuc", comment:""))
                } else {
                    SVProgressHUD.showErrorWithStatus(NSLocalizedString("S_changeFai", comment:""))
                }
                return;
            }
        }
        UIAlertView(title: NSLocalizedString("A_title", comment:""), message: NSLocalizedString("A_psd_Null", comment:""), delegate: self, cancelButtonTitle: NSLocalizedString("A_sure", comment:"")).show()
    }
}
