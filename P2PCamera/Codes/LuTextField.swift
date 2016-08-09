//
//  LuTextField.swift
//  P2PCamera
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 Lu. All rights reserved.
//

import UIKit

class LuTextField: UITextField {

    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        let inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height)
        return inset
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        let inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height)
        return inset
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        let inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height)
        return inset
    }

}
