//
//  RingTonesViewController.m
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "RingTonesViewController.h"

@interface RingTonesViewController ()

@property (nonatomic,strong) UISlider *slider;

@end

@implementation RingTonesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSetupUI];
    [self initNaviTools];
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)setupUI {
    [self setTitleText:@"RINGTONES & NOTIFICATIONS"];
    
    NSArray *setArr = @[@"TURN RINGTONE ON/OFF",@"TURN VIBRATE ON/OFF",@"TURN PUSH NOTIFICATION ON/OFF",@"TURN EMAIL ALERTS ON/OFF"];
    for (int i = 0;i<4;i++){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 64+30+i*39, lScreenWidth-20, 40)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = setArr[i];
        label.textAlignment = NSTextAlignmentLeft;
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.tag = 200+i;
        
        UISwitch *switchK = [[UISwitch alloc]initWithFrame:CGRectMake(lScreenWidth - 70, 64+33+i*39, 20, 20)];
        switchK.on = YES;
        switchK.tag = 300+i;
        
        [self.view addSubview:switchK];
        [self.view addSubview:label];
    }
    
    NSArray *nameArr = @[@"SELECT DEFAULT RINGTONE",@"IMPORT CUSTOM RINGTONE"];
    for(int i=0;i<2;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10, 64+200+60*i, lScreenWidth-20, 50);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [self.view addSubview:button];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40,  64+350, lScreenWidth-80, 70)];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, lScreenWidth-80, 40)];
    label.text = @"RINGTONE VOLUME ADJUST";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize: 15];
    label.textAlignment = NSTextAlignmentCenter;
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(10+30, 40, lScreenWidth-80-80, 15)];
    UIImageView *reduce = [[UIImageView alloc]initWithFrame:CGRectMake(10, _slider.frame.origin.y-7, 30, 30)];
    reduce.image = [UIImage imageNamed:@"reduce"];
    reduce.backgroundColor = [UIColor blackColor];
    reduce.layer.cornerRadius = 15;
    reduce.clipsToBounds = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reduce)];
    [reduce addGestureRecognizer:tap1];
    reduce.userInteractionEnabled = YES;
    
    UIImageView *plus = [[UIImageView alloc]initWithFrame:CGRectMake(lScreenWidth-40-80, _slider.frame.origin.y-7, 30, 30)];
    plus.layer.cornerRadius = 15;
    plus.clipsToBounds = YES;
    plus.backgroundColor = [UIColor blackColor];
    plus.image = [UIImage imageNamed:@"plus"];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(plus)];
    [plus addGestureRecognizer:tap2];
    plus.userInteractionEnabled = YES;
    [view addSubview:_slider];
    [view addSubview:reduce];
    [view addSubview:plus];
    [view addSubview:label];
    
    [self.view addSubview:view];
}

- (void)reduce {
    _slider.value = _slider.value - 0.1;
}

- (void)plus {
    _slider.value = _slider.value + 0.1;
}

- (void)buttonClicked:(UIButton *)button{
    
}

@end
