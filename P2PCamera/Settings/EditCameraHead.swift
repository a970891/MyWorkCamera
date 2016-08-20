//
//  EditCameraHead.swift
//  SetView
//
//  Created by 花早 on 16/5/24.
//  Copyright © 2016年 花早. All rights reserved.
//

import UIKit

class EditCameraHead: UIView {
    
    @IBOutlet weak var TitleLabel: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.TitleLabel.text = "";
    }
}

private var xoTag:Int = 0

extension UITextField {
    
    var uid:String {
        get{
            return (objc_getAssociatedObject(self, &xoTag)) as! String
        }
        set(newValue){
            objc_setAssociatedObject(self, &xoTag, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}
