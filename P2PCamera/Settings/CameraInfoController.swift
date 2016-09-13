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
        self.showNaviBackButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        modelLabel.text = cameraObj.model
        versionLabel.text = cameraObj.cameraVersion
        firmLabel.text = cameraObj.firm
        totalLabel.text = String(cameraObj.rom.integerValue/1024)
        reduceLabel.text = String(cameraObj.reduceRom.integerValue/1024)
    }
    
}
