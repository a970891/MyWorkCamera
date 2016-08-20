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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
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
