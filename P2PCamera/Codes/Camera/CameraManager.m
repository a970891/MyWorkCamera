//
//  CameraManager.m
//  P2PCamera
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "CameraManager.h"
#import "CameraObject.h"

@implementation CameraManager

+(id)sharedInstance {
    
    static CameraManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedMyManager = [[self alloc] init];
        
    });
    
    return sharedMyManager;
    
}

/**
 查询所有元素
 */
- (NSArray *)findAllObjects {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] != nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"%ld",arr.count);
        return arr;
    } else {
        return @[];
    }
}

/**
 插入元素
 */
- (BOOL)insertObject:(CameraObject *)object {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self findAllObjects]];
    for (int i = 0; i<arr.count; i++){
        CameraObject *objectTemp = arr[i];
        if ([objectTemp.uid isEqualToString:object.uid]){
            [arr replaceObjectAtIndex:i withObject:object];
             NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            return YES;
        }
    }
    [arr addObject:object];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return YES;
}

- (BOOL)deleteObject:(CameraObject *)object {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self findAllObjects]];
    for (int i = 0; i<arr.count; i++){
        CameraObject *objectTemp = arr[i];
        if ([object.uid isEqualToString:objectTemp.uid]) {
            [arr removeObject:objectTemp];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            return true;
        }
    }
    return false;
}

@end
