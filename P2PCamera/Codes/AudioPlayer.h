//
//  AudioPlayer.h
//  P2PCamera
//
//  Created by meizu on 16/4/16.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SearchBlock)(NSString *str);

@interface AudioPlayer : NSObject
- (void)IOTC_Init;
- (NSString *)SearchAndConnect;
@end
