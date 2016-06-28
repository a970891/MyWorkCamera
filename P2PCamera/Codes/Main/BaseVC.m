//
//  BaseVC.m
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *titleLine;
@property (nonatomic,strong) UIImageView * backgroundImage;

@property (nonatomic,strong) UIImageView *leftButton;
@property (nonatomic,strong) UIImageView *rightButton;

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)initSetupUI{
    self.navigationController.navigationBar.hidden = YES;
    _backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, lScreenWidth, lScreenHeight)];
    _backgroundImage.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, lScreenWidth, 40)];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    
    _titleLine = [[UIView alloc]initWithFrame:CGRectMake(10, 64-_px, lScreenWidth-20, _px)];
    _titleLine.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_backgroundImage];
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_titleLine];
}

- (void)initNaviTools {
    _leftButton = [[UIImageView alloc]initWithFrame:CGRectMake(10, lScreenHeight-20-44, 44, 44)];
    _leftButton.image = [UIImage imageNamed:@"backBtn"];
//    [_leftButton setBackgroundColor:[UIColor blackColor]];
    _leftButton.contentMode = UIViewContentModeScaleAspectFit;
    _leftButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonAction)];
    [_leftButton addGestureRecognizer:tap];
    
    _rightButton = [[UIImageView alloc]initWithFrame:CGRectMake(lScreenWidth-10-44, lScreenHeight-20-44, 44, 44)];
    _rightButton.image = [UIImage imageNamed:@"homeBtn"];
    _rightButton.contentMode = UIViewContentModeScaleAspectFit;
    _rightButton.userInteractionEnabled = YES;
//    [_rightButton setBackgroundColor:[UIColor blackColor]];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightButtonAction)];
    [_rightButton addGestureRecognizer:tap1];
    
    [self.view addSubview:_leftButton];
    [self.view addSubview:_rightButton];
}

- (void)setTitleText:(NSString *)text {
    _titleLabel.text = text;
}

- (void)leftButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
