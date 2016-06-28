//
//  SetTableViewController.swift
//  SetView
//
//  Created by 花早 on 16/5/24.
//  Copyright © 2016年 花早. All rights reserved.
//

import UIKit

class SetTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? SetSelectorTV {
            vc.setClosure = {
                print($0)
            }
        }else{
            print("非SetSelectorTV类")
        }
    }
    
}


extension NSObject {
    /*!
     根据SB的名字和标识获取其控制器
     - parameter storyboardName: 故事板名字
     - parameter Identifier:     标识
     
     - returns: Con
     */
    func StoryboardWithIdentifier(storyboardName:String,Identifier:String)-> UIViewController{
        let temStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = temStoryboard.instantiateViewControllerWithIdentifier(Identifier)
        return vc
    }
}