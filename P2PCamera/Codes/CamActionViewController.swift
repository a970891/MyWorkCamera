//
//  CamActionViewController.swift
//  P2PCamera
//
//  Created by 易风 on 16/9/11.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit

class CamActionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    private var titleLabel:UILabel!
    private var tableView:UITableView!
    private var dataSource = [ActionObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        self.view.backgroundColor = UIColor.whiteColor()
        
        let line = UIView(frame: CGRectMake(0,64,SW,1))
        line.backgroundColor = UIColor.lightGrayColor()
        
        titleLabel = UILabel(frame: CGRectMake(0,20,SW,44))
        titleLabel.text = Myself.getCurrentLanguage() ? "Actions" : "事件"
        titleLabel.font = UIFont.systemFontOfSize(18)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.blackColor()
        
        tableView = UITableView(frame: CGRectMake(0, 64, SW, SW-64-49))
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(CamActionCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(line)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.dataSource = ActionManager.getObjects()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = ActionCellVC()
        vc.name = self.dataSource[indexPath.row].name
        vc.dataSource = self.dataSource[indexPath.row].actions
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CamActionCell
        cell.setObject(self.dataSource[indexPath.row])
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
}

class CamActionCell:UITableViewCell {
    private var titleLabel:UILabel!
    private var uidLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UILabel(frame: CGRectMake(15,30,40,40))
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.blackColor()
        
        uidLabel = UILabel(frame: CGRectMake(65,30,SW-110,40))
        uidLabel.font = UIFont.systemFontOfSize(12)
        uidLabel.textAlignment = NSTextAlignment.Left
        uidLabel.textColor = UIColor.blackColor()
        
        self.addSubview(titleLabel)
        self.addSubview(uidLabel)
    }
    
    func setObject(object:ActionObject) {
        titleLabel.text = object.name
        uidLabel.text = "uid" + object.uid
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ActionObject:NSObject,NSCoding{
    dynamic var uid:String = ""
    dynamic var name:String = ""
    dynamic var actions = [String:String]()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.uid = aDecoder.decodeObjectForKey("uid") as! String
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.actions = aDecoder.decodeObjectForKey("actions") as! [String:String]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.uid, forKey: "uid")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.actions, forKey: "actions")
    }
}

class ActionCellVC:UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    private var titleLabel:UILabel!
    private var tableView:UITableView!
    private var name:String = ""
    private var dataSource = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        self.view.backgroundColor = UIColor.whiteColor()
        
        let line = UIView(frame: CGRectMake(0,64,SW,1))
        line.backgroundColor = UIColor.lightGrayColor()
        
        titleLabel = UILabel(frame: CGRectMake(0,20,SW,44))
        titleLabel.text = self.name
        titleLabel.font = UIFont.systemFontOfSize(18)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.blackColor()
        
        tableView = UITableView(frame: CGRectMake(0, 64, SW, SW-64-49))
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(ActionCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(line)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.keys.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ActionCell
        let str = (self.dataSource as NSDictionary).allKeys[indexPath.row] as! String
        cell.setObject([str:self.dataSource[str]!])
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
}

class ActionCell:UITableViewCell {
    private var titleLabel:UILabel!
    private var uidLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UILabel(frame: CGRectMake(105,30,SW-150,40))
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.blackColor()
        
        uidLabel = UILabel(frame: CGRectMake(15,30,80,40))
        uidLabel.font = UIFont.systemFontOfSize(12)
        uidLabel.textAlignment = NSTextAlignment.Left
        uidLabel.textColor = UIColor.blackColor()
        
        self.addSubview(titleLabel)
        self.addSubview(uidLabel)
    }
    
    func setObject(dic:[String:String]) {
        titleLabel.text = self.timeStampToString(dic.keys.first!)
        uidLabel.text = dic[dic.keys.first!]
    }
    
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy.MM.dd-HH.mm.ss"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

