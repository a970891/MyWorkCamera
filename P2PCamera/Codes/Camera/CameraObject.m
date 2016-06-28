//
//  CameraObject.m
//  P2PCamera
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "CameraObject.h"

@implementation CameraObject

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_uid forKey:@"UID"];
    [aCoder encodeObject:_password forKey:@"password"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _uid = [aDecoder decodeObjectForKey:@"UID"];
        _password = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.uid = @"";
        self.password = @"";
    }
    return self;
}

@end
