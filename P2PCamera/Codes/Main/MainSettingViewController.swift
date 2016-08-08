//
//  MainSettingViewController.swift
//  P2PCamera
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit

class MainSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        let image = UIImageView(frame: CGRectMake(40, 64+(SH-64-(SW-80))/3, SW-80, SW-80))
        image.image = QRCodeGenerator.qrImageForString("uid:xxxxx", imageSize: SW-80)
        self.view.addSubview(image)
        
        let button = UIButton(frame: CGRectMake(12,20,44,44))
        button.setBackgroundImage(UIImage(named: "backBtn"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.popAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        let line = UIView(frame: CGRectMake(0,64,SW,1))
        line.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(line)
        
        let titleLabel = UILabel(frame: CGRectMake(0,20,SW,44))
        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.text = "设置"
        titleLabel.textColor = UIColor.blackColor()
        self.view.addSubview(titleLabel)
        titleLabel.textAlignment = NSTextAlignment.Center
        
        let tableView = UITableView(frame: CGRectMake(0,65,SW,SH-65))
        tableView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(MainSettingTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(tableView)
    }
    
    func popAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK : tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MainSettingTableViewCell
        cell.setTitle(["二维码WiFi","SMARTLINK","删除摄像头"][indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let vc = QRCodeViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
