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
            let alert = UIAlertView(title: "提示", message: "设置wifi网络", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确认")
            alert.alertViewStyle = UIAlertViewStyle.LoginAndPasswordInput
            let f1 = alert.textFieldAtIndex(0)
            let f2 = alert.textFieldAtIndex(1)
            f1?.placeholder = "请输入wifi名(ssid)"
            f2?.placeholder = "请输入wifi密码"
            alert.tag = 150
            alert.show()
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
        if alertView.tag == 150 {
            let f1 = alertView.textFieldAtIndex(0)
            let f2 = alertView.textFieldAtIndex(1)
            if let f1x = f1?.text, f2x = f2?.text {
                if f1x.characters.count != 0 || f2x.characters.count != 0 {
                    SVProgressHUD.showSuccessWithStatus("设置完成!")
                    self.cameraObj.ssid = f1x
                    self.wifiLabel.text = f1x
                    
                    return;
                }
            }
            UIAlertView(title: "提示", message: "ssid或密码不能为空", delegate: self, cancelButtonTitle: "好").show()
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