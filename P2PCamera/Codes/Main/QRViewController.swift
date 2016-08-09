//
//  QRViewController.swift
//  P2PCamera
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit

class QRViewController: UIViewController {

    var ssid:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let image = UIImageView(frame: CGRectMake(40, 64+(SH-64-(SW-80))/3, SW-80, SW-80))
        image.image = QRCodeGenerator.qrImageForString("str", imageSize: SW-80)
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
        titleLabel.text = "二维码WiFi"
        titleLabel.textColor = UIColor.blackColor()
        self.view.addSubview(titleLabel)
        titleLabel.textAlignment = NSTextAlignment.Center
    }
    
    func popAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
