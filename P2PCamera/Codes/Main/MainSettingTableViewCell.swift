//
//  MainSettingTableViewCell.swift
//  P2PCamera
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit

class MainSettingTableViewCell: UITableViewCell {

    private var titleLabel:UILabel!
    
    private var bgView:UIView!
    private var mainView:UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        bgView = UIView(frame: CGRectMake(0,0,SW,100))
        bgView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        mainView = UIView(frame: CGRectMake(0,40,SW,60))
        mainView.backgroundColor = UIColor.whiteColor()
        
        titleLabel = UILabel(frame: CGRectMake(20,0,120,60))
        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        
        self.addSubview(bgView)
        self.addSubview(mainView)
        mainView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title:String) {
        self.titleLabel.text = title
    }

}
