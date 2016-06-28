//
//  CameraObject.h
//  P2PCamera
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraObject : NSObject <NSCoding>

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *password;

@end
