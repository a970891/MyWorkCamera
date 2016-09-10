//
//  CameraViewController.h
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "BaseVC.h"

typedef void (^SendVoiceBlock)(Byte *buffer,NSData *data);

@interface CameraViewController : BaseVC

- (CameraViewController *)initWithUid:(NSString *)uid password:(NSString *)password;

@property (nonatomic,copy) SendVoiceBlock sendBlock;

@end
