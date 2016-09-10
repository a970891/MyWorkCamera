//
//  CameraViewController.h
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "BaseVC.h"
#import "CameraObject.h"

typedef void (^SendVoiceBlock)(Byte *buffer,NSData *data);

@interface CameraViewController : BaseVC

- (CameraViewController *)initWithObject:(CameraObject *)object;

@property (nonatomic,copy) SendVoiceBlock sendBlock;

@end
