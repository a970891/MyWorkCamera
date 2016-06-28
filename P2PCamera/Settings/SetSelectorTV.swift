//
//  SetSelectorTV.swift
//  SetView
//
//  Created by 花早 on 16/5/24.
//  Copyright © 2016年 花早. All rights reserved.
//

import UIKit
typealias selectorClosure=(index:Int)->()
class SetSelectorTV: UITableViewController{
    
    var setClosure:selectorClosure?
    var selectTem = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
