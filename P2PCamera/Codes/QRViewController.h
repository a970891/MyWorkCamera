//
//  QRViewController.h
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavViewController.h"

typedef void(^QRUrlBlock)(NSString *url);
@interface QRViewController : MyNavViewController


@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@end
