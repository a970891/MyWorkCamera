//
//  BasicDefinetion.h
//  MyBiLiBiLi
//
//  Created by mac on 15/7/17.
//  Copyright (c) 2015年 XWZ. All rights reserved.
//

#ifndef MyBiLiBiLi_BasicDefinetion_h
#define MyBiLiBiLi_BasicDefinetion_h

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define lScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define lScreenHeight ([[UIScreen mainScreen] bounds].size.height)

#define AUTO_WIDTH ((SCREEN_WIDTH)*1.0/320)
#define AUTO_HEIGHT ((SCREEN_HEIGHT)*1.0/568)

#define isFirstLaunchKey @"isFirstLaunchKey"

#define MineHeadCellLoginedReuseID @"MineHeadCellLoginedReuseID"
#define MineHeadCellUnLoginedReuseID @"MineHeadCellUnLoginedReuseID"
#define MineBodyCellReuseID @"MineBodyCellReuseID"

#define MyViewHeadCellReuseID @"MyViewHeadCellReuseID"
#define MyViewBodyCellReuseID @"MyViewBodyCellReuseID"

#define FontAuto ((SCREEN_WIDTH)*1.0/320)

#define AT (1.0/480*SCREEN_WIDTH)
#define ATB (1.0/1080*SCREEN_WIDTH)
#define ATN (1.0/525*SCREEN_WIDTH)
#define ATM (1.0/720*SCREEN_WIDTH)
#define ATK (1.0/780*SCREEN_WIDTH)

#define ATD (1.0/1147*SCREEN_WIDTH)

#define ATF (1.0/1080*SCREEN_WIDTH)

#define _px (1.0/[[UIScreen mainScreen] scale])

#define API @"http://mmw.os3d.cn/appapi/?url="

#define VERSION @"1.0.0"
#define RGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1]

#endif
