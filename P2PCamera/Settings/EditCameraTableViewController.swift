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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    
    func saveButtonAction() {
        
    }
}
