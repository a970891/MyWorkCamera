//
//  MyNavViewController.m
//  SmartCity
//
//  Created by mac on 15/7/10.
//  Copyright (c) 2015年 QF. All rights reserved.
//

#import "MyNavViewController.h"
#import "BasicDefinetion.h"

@interface MyNavViewController ()



@end

@implementation MyNavViewController

//缺省调用方法
- (void)setViewDidLoadWithBackButton:(BOOL)is_back_show andBackImage:(UIImage *)imgBack andBFrame:(CGRect)backBFrame andRightButton:(BOOL)is_right_show andRightImage:(UIImage *)imgRight andRFrame:(CGRect)rightBFrame andAlpha:(CGFloat)alpha_point andTitle:(NSString *)title
{
    self.myAlpha = alpha_point;
    [self setMyNavBar];
    if(is_back_show){
        self.backButtonImage = imgBack;
        [self showBackButton];
        if(![NSStringFromCGRect(backBFrame) isEqualToString:NSStringFromCGRect(CGRectZero)]){
            self.backButton.frame = backBFrame;
        }
    }
    if(is_right_show){
        self.rightButtonImage = imgRight;
        [self showRightButton];
        if(![NSStringFromCGRect(backBFrame) isEqualToString:NSStringFromCGRect(CGRectZero)]){
            self.rightButton.frame = rightBFrame;
        }
    }
    self.titleLabel.text = title;
}


//显示返回按钮
- (void)showBackButton
{
    self.backButton.frame = CGRectMake(10*AUTO_WIDTH, 20*AUTO_HEIGHT, 30*AUTO_HEIGHT, 44*AUTO_HEIGHT);
    [self.backButton setImage:self.backButtonImage forState:UIControlStateNormal];
    [self.backButton setTintColor:[UIColor whiteColor]];
    [self.backButton addTarget:self action:@selector(backButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setContentMode:UIViewContentModeCenter];
    [self.view addSubview:self.backButton];
    self.backButton.hidden = NO;
}

//显示右侧按钮
- (void)showRightButton
{
    self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightButton.frame = CGRectMake(275*AUTO_WIDTH, 30*AUTO_HEIGHT, 30*AUTO_WIDTH, 27*AUTO_HEIGHT);
    [self.rightButton setImage:self.rightButtonImage forState:UIControlStateNormal];
    [self.rightButton setTintColor:[UIColor blackColor]];
    [self.rightButton setContentMode:UIViewContentModeCenter];
    [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightButton];
    self.rightButton.hidden = NO;
}

- (void)showLeftButton{
    [self.view addSubview:self.leftButton];
}

//返回按钮点击事件
- (void)backButtonDidClicked:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


//右侧按钮点击事件
- (void)rightButtonAction:(UIButton *)button
{
     
}

- (void)popToParentsVC:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

//显示导航栏
- (void)setMyNavBar
{
    self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64*AUTO_HEIGHT)];
//    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.alpha = self.myAlpha;
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 63.5*AUTO_HEIGHT, SCREEN_WIDTH, 0.5*AUTO_HEIGHT)];
    _line.backgroundColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0];
    [self.view addSubview:_line];
//    self.navBar.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.titleLabel];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

//--------------lazy init

- (UIButton *)backButton
{
    if(_backButton == nil){
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _backButton.hidden = YES;
    }
    return _backButton;
}

- (UILabel *)titleLabel
{
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-45*AUTO_WIDTH, 32*AUTO_HEIGHT, 90*AUTO_WIDTH, 20*AUTO_HEIGHT)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UIImage *)backButtonImage
{
    if(!_backButtonImage){
        _backButtonImage = [[UIImage alloc]init];
    }
    return _backButtonImage;
}

- (UIImage *)rightButtonImage
{
    if(!_rightButtonImage){
        _rightButtonImage = [[UIImage alloc]init];
    }
    return _rightButtonImage;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftButton.frame = CGRectMake(27*AUTO_WIDTH, 30*AUTO_HEIGHT, 30*AUTO_WIDTH, 27*AUTO_HEIGHT);
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(popToParentsVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
