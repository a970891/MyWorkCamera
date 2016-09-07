//
//  SetTableViewController.swift
//  SetView
//
//  Created by 花早 on 16/5/24.
//  Copyright © 2016年 花早. All rights reserved.
//

import UIKit

class SetTableViewController: UITableViewController,UIAlertViewDelegate {

    var cameraObj:CameraObject!
    var tutkManager:TutkP2PAVClient!
    var wifis = [wifiObject]()
    
    @IBOutlet weak var qualtyLabel: UILabel!
    @IBOutlet weak var videoTurnLabel: UILabel!
    @IBOutlet weak var environmentLabel: UILabel!
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var moveDetect: UILabel!
    @IBOutlet weak var recordModeLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? SetQualityController {
            vc.cameraObj = cameraObj
            vc.tutkManager = tutkManager
        }
        if let vc = segue.destinationViewController as? SetVideoModeController {
            vc.cameraObj = cameraObj
            vc.tutkManager = tutkManager
        }
        if let vc = segue.destinationViewController as? SetEnvironmentModeController {
            vc.cameraObj = cameraObj
            vc.tutkManager = tutkManager
        }
        if let vc = segue.destinationViewController as? SetMotionDetectController {
            vc.cameraObj = cameraObj
            vc.tutkManager = tutkManager
        }
        if let vc = segue.destinationViewController as? SetRecordModeController {
            vc.cameraObj = cameraObj
            vc.tutkManager = tutkManager
        }
        if let vc = segue.destinationViewController as? CameraInfoController {
            vc.cameraObj = cameraObj
            vc.tutkManager = tutkManager
        }
        if let vc = segue.destinationViewController as? SetPasswordController {
            vc.cameraObj = cameraObj
            vc.tutkManager = tutkManager
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setInfo()
    }
    
    func setInfo() {
        //wifi
        if cameraObj.ssid == "" || cameraObj.ssid == "关闭" {
            cameraObj.ssid = "关闭"
        }
        self.wifiLabel.text = cameraObj.ssid
        //视频质量
        switch cameraObj.quality.intValue {
        case 0:
            self.qualtyLabel.text = "最高"
            break;
        case 1:
            self.qualtyLabel.text = "高"
            break;
        case 2:
            self.qualtyLabel.text = "中"
            break;
        case 3:
            self.qualtyLabel.text = "低"
            break;
        case 4:
            self.qualtyLabel.text = "最低"
            break;
        default:
            self.qualtyLabel.text = "未知"
            break;
        }
        //移动侦测
        switch cameraObj.motionDetect.intValue {
        case 0:
            self.moveDetect.text = "关闭"
            break
        case 1:
            self.moveDetect.text = "低"
            break
        case 2:
            self.moveDetect.text = "适中"
            break
        case 3:
            self.moveDetect.text = "高"
            break
        case 4:
            self.moveDetect.text = "最高"
            break
        default:
            break
        }
        //环境模式
        switch cameraObj.placeMode.intValue {
        case 0:
            self.environmentLabel.text = "室内50HZ模式"
            break;
        case 1:
            self.environmentLabel.text = "室内60HZ模式"
            break;
        case 2:
            self.environmentLabel.text = "室外模式"
            break;
        case 3:
            self.environmentLabel.text = "夜间模式"
            break;
        default:
            break;
        }
        //画面翻转
        switch cameraObj.videoMode.intValue {
        case 0:
            self.videoTurnLabel.text = "一般"
            break
        case 1:
            self.videoTurnLabel.text = "垂直翻转"
            break
        case 2:
            self.videoTurnLabel.text = "水平翻转(镜像)"
            break
        case 3:
            self.videoTurnLabel.text = "垂直及水平翻转"
            break
        default:
            break
        }
        //录像模式
        switch cameraObj.recordMode.intValue {
        case 0:
            self.recordModeLabel.text = "关闭"
            break;
        case 1:
            self.recordModeLabel.text = "全景"
            break;
        case 2:
            self.recordModeLabel.text = "警报"
            break;
        case 3:
            self.recordModeLabel.text = "普通"
            break;
        default:
            break;
        }
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 5 {
            let alert = UIAlertView(title: "提示", message: "是否格式化SD卡", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "好")
            alert.tag = 140
            alert.show()
        }
        if indexPath.section == 2 {
            let vc = wifiViewController()
            print(vc.wifis);
            vc.wifis = self.wifis
            vc.tutkManager = tutkManager
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 140 {
            if buttonIndex == 0 {
                return;
            } else {
                SVProgressHUD.showWithStatus("格式化SD卡中")
                if tutkManager.getStorage() == -1 {
                    SVProgressHUD.showErrorWithStatus("格式化失败")
                }else {
                    SVProgressHUD.showSuccessWithStatus("格式化成功")
                }
            }
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

class wifiViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    var wifis = [wifiObject]()
    private var tableView:UITableView!
    var tutkManager:TutkP2PAVClient!
    private var selectSsid:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        tableView = UITableView(frame: CGRectMake(0, 0, SW, SH-64))
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(wifiCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wifis.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! wifiCell
        cell.setCell(self.wifis[indexPath.row].ssid)
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectSsid = self.wifis[indexPath.row].ssid
        let alertView = UIAlertView(title: "提示", message: "请输入密码", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
        let textField = alertView.textFieldAtIndex(0)
        textField?.placeholder = "密码"
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if let textField = alertView.textFieldAtIndex(0) {
                if let text = textField.text {
                    if (text as NSString).length != 0 {
                        tutkManager.setWifi(self.selectSsid, pwd: text)
                        self.navigationController?.popViewControllerAnimated(true)
                        return
                    }
                }
            }
            SVProgressHUD.showErrorWithStatus("密码不能为空!")
        }
    }

}

class wifiCell:UITableViewCell {
    
    private var titleLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        let bgView = UIView(frame: CGRectMake(0,10,SW,40))
        bgView.backgroundColor = UIColor.whiteColor()
        
        titleLabel = UILabel(frame: CGRectMake(12,0,SW-24,40))
        titleLabel.backgroundColor = UIColor.whiteColor()
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textAlignment = NSTextAlignment.Left
        
        bgView.addSubview(titleLabel)
        self.addSubview(bgView)
    }
    
    func setCell(text:String) {
        self.titleLabel.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}