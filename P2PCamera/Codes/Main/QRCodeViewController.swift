//
//  QRCodeViewController.swift
//  P2PCamera
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit

let SW = UIScreen.mainScreen().bounds.size.width
let SH = UIScreen.mainScreen().bounds.size.height

class QRCodeViewController: UIViewController,UITextFieldDelegate {

    private var iconLogo:UIImageView!
    private var nowWifi:YYLabel!
    private var changeWifi:YYLabel!
    private var password:LuTextField!
    private var nextButton:UIButton!
    private var mainView:UIView!
    
    private var ssid:String = ""
    
    private var nowWifiStringA:NSMutableAttributedString!
    private var nowWifiStringB:NSMutableAttributedString!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(QRCodeViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillDisappear:"), name: UIKeyboardWillHideNotification, object: nil)

//        let image = UIImageView(frame: CGRectMake(40, 64+(SH-64-(SW-80))/3, SW-80, SW-80))
//        image.image = QRCodeGenerator.qrImageForString("uid:xxxxx", imageSize: SW-80)
//        self.view.addSubview(image)
        
        let refresh = UIButton(frame: CGRectMake(SW-12-60, 30, 60, 24))
        refresh.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        refresh.setTitle("刷新", forState: UIControlState.Normal)
        refresh.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        refresh.titleLabel?.font = UIFont.systemFontOfSize(13)
        refresh.addTarget(self, action: #selector(QRCodeViewController.refreshAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(refresh)
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(lScreenWidth-12-24, 30, 24, 24)];
        //    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //    [button setTitle:@"二维码" forState:UIControlStateNormal];
        //    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //    button.titleLabel.font = [UIFont systemFontOfSize:13];
        
        let button = UIButton(frame: CGRectMake(12,20,44,44))
        button.setBackgroundImage(UIImage(named: "backBtn"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(QRCodeViewController.popAction), forControlEvents: UIControlEvents.TouchUpInside)
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
        self.setupUI()
    }
    
    func refreshAction() {
        let str = SystemWifiManager.getSSID()
        ssid = str
        nowWifiStringB = NSMutableAttributedString(string: " "+str)
        nowWifiStringB.yy_color = UIColor.blackColor()
        nowWifiStringB.yy_font = UIFont.systemFontOfSize(13)
        let strA = NSMutableAttributedString(string: "")
        strA.appendAttributedString(nowWifiStringA)
        strA.appendAttributedString(nowWifiStringB)
        self.nowWifi.attributedText = strA
        nowWifi.textAlignment = NSTextAlignment.Center
    }
    
    func setupUI() {
        mainView = UIView(frame: CGRectMake(0,65,SW,SH-65))
        
        iconLogo = UIImageView(frame:CGRectMake((SW-80)/2, (SW-80)/4, 80, 80))
        iconLogo.image = UIImage(named: "router_icon")
        
        nowWifi = YYLabel()
        nowWifiStringA = NSMutableAttributedString(string: "当前Wi-Fi:")
        nowWifiStringA.yy_color = UIColor.lightGrayColor()
        nowWifiStringA.yy_font = UIFont.systemFontOfSize(13)
        nowWifi.frame = CGRectMake(0, iconLogo.frame.origin.y + 100, SW, 25)
        
        changeWifi = YYLabel()
        let changeWifiString = NSMutableAttributedString(string: "更换其他Wi-Fi")
        changeWifiString.yy_font = UIFont.systemFontOfSize(13)
        let aValue = NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)
        changeWifiString.addAttribute(NSUnderlineStyleAttributeName, value: aValue, range: NSMakeRange(0, 9))
        changeWifiString.yy_color = UIColor(red: 91/255, green: 187/255, blue: 247/255, alpha: 1.0)
        changeWifi.frame = CGRectMake(0, nowWifi.frame.origin.y + 35, SW, 25)
        changeWifiString.yy_setTextHighlightRange(NSMakeRange(0, 9), color: UIColor(red: 91/255, green: 187/255, blue: 247/255, alpha: 1.0), backgroundColor: UIColor.clearColor()) { (view, string, range, frame) in
            UIApplication.sharedApplication().openURL(NSURL(string: "prefs:root=WIFI")!)
        }
        changeWifi.attributedText = changeWifiString
        changeWifi.textAlignment = NSTextAlignment.Center
        
        password = LuTextField(frame: CGRectMake(40,changeWifi.frame.origin.y + 85,SW-80,30))
        password.layer.cornerRadius = 5
        password.delegate = self
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor.lightGrayColor().CGColor
        password.placeholder = "请输入密码"
        password.font = UIFont.systemFontOfSize(14)
        
        nextButton = UIButton(frame: CGRectMake(40,password.frame.origin.y + 75,SW-80,30))
        nextButton.setTitle("下一步", forState: UIControlState.Normal)
        nextButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        nextButton.setTitleColor(UIColor(red: 91/255, green: 187/255, blue: 247/255, alpha: 1.0), forState: UIControlState.Normal)
        nextButton.layer.cornerRadius = 15
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        nextButton.addTarget(self, action: #selector(QRCodeViewController.gotoQRCodeVC), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(mainView)
        mainView.addSubview(iconLogo)
        mainView.addSubview(changeWifi)
        mainView.addSubview(nowWifi)
        mainView.addSubview(password)
        mainView.addSubview(nextButton)
    }
    
    func gotoQRCodeVC() {
        if self.ssid != "" {
            if password.text != "" && password.text != nil{
                let str = "###" + ssid + "###" + password.text!
                let vc = QRViewController()
                vc.ssid = str
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        UIAlertView(title: "提示", message: "未选择Wi-Fi或未填写密码", delegate: self, cancelButtonTitle: "好").show()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshAction()
    }
    
    func popAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func keyboardWillAppear(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let height = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                UIView.animateWithDuration(0.25, animations: {
                    self.mainView.frame = CGRectMake(0, 65-100, SW, SH-65)
                })
            }
        }
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        UIView.animateWithDuration(0.25, animations: {
            self.mainView.frame = CGRectMake(0, 65, SW, SH-65)
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.password.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
