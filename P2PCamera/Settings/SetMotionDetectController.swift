//
//  SetMotionDetectController.swift
//  P2PCamera
//
//  Created by mac on 16/8/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit

class SetMotionDetectController: UITableViewController {

    var setClosure:selectorClosure?
    var selectTem = 0
    var cameraObj:CameraObject!
    var tutkManager:TutkP2PAVClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectTem = self.cameraObj.motionDetect.integerValue
        if self.selectTem == -1 {
            self.selectTem = 0
        }
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        cell1?.accessoryType = .None
        let cell3 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectTem, inSection: 0))
        cell3?.accessoryType = .Checkmark
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tutkManager.setMotionDetece(Int32(indexPath.row))
        cameraObj.motionDetect = NSNumber(integer:indexPath.row)
        if indexPath.row != selectTem{
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectTem, inSection: 0)){
                cell.accessoryType = .None
                //记录当前的
                self.selectTem = indexPath.row
                if let selectorCell = tableView.cellForRowAtIndexPath(indexPath){
                    selectorCell.accessoryType = .Checkmark
                }
            }
            
        }
        if (setClosure != nil) {
            self.setClosure!(index: indexPath.row)
        }
    }

}
