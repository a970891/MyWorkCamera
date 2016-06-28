//
//  MyNavViewController.h
//  SmartCity
//
//  Created by LDJ on 15/9/30.
//  Copyright (c) 2015年 MEIZU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicDefinetion.h"
@interface MyNavViewController : UIViewController

//成员变量

@property (nonatomic,strong) UIView *navBar;        //导航栏界面

@property (nonatomic,strong) UILabel *titleLabel;   //标题label
@property (nonatomic,strong) UIImageView *line;     //分割线
@property (nonatomic,strong) UIButton *backButton;  //返回按钮
@property (nonatomic,strong) UIButton *rightButton; //右侧按钮
@property (nonatomic,strong) UIButton *leftButton;

@property (nonatomic,strong) UIImage *rightButtonImage; //右侧按钮图片
@property (nonatomic,strong) UIImage *backButtonImage;  //返回按钮图片
@property (nonatomic,assign) CGFloat myAlpha;           //导航栏透明度alpha

- (void)setMyNavBar;

- (void)showBackButton;
- (void)showRightButton;
- (void)showLeftButton;

- (UILabel *)titleLabel;

//***************************************下面是建议调用的方法************************************

//右侧按钮点击事件
- (void)rightButtonAction:(UIButton *)button;
//返回按钮点击事件
- (void)backButtonDidClicked:(UIButton *)button;

//请在页面继承后的viewDidLoad运行此方法
- (void)setViewDidLoadWithBackButton:(BOOL)is_back_show     //是否显示返回按钮
                        andBackImage:(UIImage *)imgBack     //返回按钮图片(没有就传nil)
                           andBFrame:(CGRect)backBFrame  //返回按钮frame,传CGRectZero则选择默认尺寸
                      andRightButton:(BOOL)is_right_show    //是否显示右侧按钮
                       andRightImage:(UIImage *)imgRight    //右侧按钮图片(没有就传nil)
                           andRFrame:(CGRect)rightBFrame //右侧按钮frame,传传CGRectZero则选择默认尺寸
                            andAlpha:(CGFloat)alpha_point   //导航栏alpha值
                            andTitle:(NSString *)title;     //标题
@end
