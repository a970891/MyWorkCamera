//
//  CameraManager.h
//  P2PCamera
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraObject.h"

@interface CameraManager : NSObject

+(id) sharedInstance;

- (NSArray *)findAllObjects;

- (BOOL)insertObject:(CameraObject *)object;

@end
