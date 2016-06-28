//
//  BaseVC.h
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicDefinetion.h"

@interface BaseVC : UIViewController

//启动设置
- (void)initSetupUI;

//设置导航按钮
- (void)initNaviTools;

- (void)setTitleText:(NSString *)text;

- (void)rightButtonAction;

- (void)leftButtonAction;

@end
