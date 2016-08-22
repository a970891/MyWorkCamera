//
//  SetTableViewController.swift
//  SetView
//
//  Created by 花早 on 16/5/24.
//  Copyright © 2016年 花早. All rights reserved.
//

import UIKit

class SetTableViewController: UITableViewController {

    var cameraObj:CameraObject!
    
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
        if let vc = segue.destinationViewController as? SetSelectorTV {
            vc.setClosure = {
                print($0)
            }
        }else{
            print("非SetSelectorTV类")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setInfo()
    }
    
    func setInfo() {
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
            self.videoTurnLabel.text = "正常"
            break
        case 1:
            self.videoTurnLabel.text = "翻转"
            break
        case 2:
            self.videoTurnLabel.text = "镜像"
            break
        case 3:
            self.videoTurnLabel.text = "翻转镜像"
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