//
//  ZHLTTabBar.h
//  G1APP
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 ZHLT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHLTTabBar : UIControl

//保存内容用的
@property   (nonatomic,strong)  UIImage     *normalImage;
@property   (nonatomic,strong)  UIImage     *selectedImage;
@property   (nonatomic,copy)    NSString    *title;

//显示用的两个属性
@property   (nonatomic,strong)  UIImageView *imageView;
@property   (nonatomic,strong)  UILabel     *titleLabel;

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title  normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage;


@end
