//
//  ViewController.swift
//  SetView
//
//  Created by 花早 on 16/5/24.
//  Copyright © 2016年 花早. All rights reserved.
//
import UIKit

extension UIViewController{
    
    //返回上一层
    @IBAction func popLastViewVc(sender:AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //退场回调
    @IBAction func unwindWithSelector(segue:UIStoryboardSegue){
        
    }
    
    //返回上一层并且打开navi
    @IBAction func popLastViewVcAndOpenNav(sender:AnyObject){
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = false;
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
