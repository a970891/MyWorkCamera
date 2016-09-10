//
//  CameraObject.h
//  P2PCamera
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraObject : NSObject <NSCoding>

@property (nonnull,nonatomic,copy) NSString *uid;                       //串号
@property (nonnull,nonatomic,copy) NSString *password;                  //密码
@property (nonnull,nonatomic,copy) NSString *name;                      //名字
@property (nonnull,nonatomic,copy) NSString *ssid;                      //ssid
@property (nonnull,nonatomic,copy) NSNumber *quality;                   //视频质量
@property (nonnull,nonatomic,copy) NSNumber *turnVideo;                 //画面翻转
@property (nonnull,nonatomic,copy) NSNumber *placeMode;                 //环境模式
@property (nonnull,nonatomic,copy) NSNumber *motionDetect;              //移动侦测
@property (nonnull,nonatomic,copy) NSNumber *recordMode;                //录像模式
@property (nonnull,nonatomic,copy) NSNumber *videoMode;                 //视频模式
@property (nonnull,nonatomic,copy) NSString *model;                     //录像机model
@property (nonnull,nonatomic,copy) NSString *cameraVersion;             //录像机versionCode
@property (nonnull,nonatomic,copy) NSString *firm;                      //厂商
@property (nonnull,nonatomic,copy) NSNumber *reduceRom;                 //剩余空间
@property (nonnull,nonatomic,copy) NSNumber *rom;                       //总空间
@property (nonnull,nonatomic,copy) NSString *connectStatus;             //连接状态

@end
