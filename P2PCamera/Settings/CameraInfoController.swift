//
//  CameraInfoController.swift
//  P2PCamera
//
//  Created by mac on 16/8/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit

class CameraInfoController: UITableViewController {

    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var firmLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var reduceLabel: UILabel!
    
    
    var setClosure:selectorClosure?
    var selectTem = 0
    var cameraObj:CameraObject!
    var tutkManager:TutkP2PAVClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}