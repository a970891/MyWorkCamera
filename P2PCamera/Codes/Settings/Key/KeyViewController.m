//
//  KeyViewController.m
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "KeyViewController.h"

@interface KeyViewController ()

@end

@implementation KeyViewController

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
    
    NSArray *setArr = @[@"TURN E-KEY FEATURE ON/OFF"];
    for (int i = 0;i<1;i++){
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
    
    NSArray *nameArr = @[@"ASSIGN E-KEYS TO USERS",@"SPECIFY DATA & TIME USAGE"];
    for(int i=0;i<2;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10, 64+90+60*i, lScreenWidth-20, 50);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [self.view addSubview:button];
    }
    
}

- (void)buttonClicked:(UIButton *)button{
    
}

@end
