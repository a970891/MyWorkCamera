//
//  WIFIViewController.m
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "WIFIViewController.h"

@interface WIFIViewController ()

@end

@implementation WIFIViewController

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
    [self setTitleText:@"WI-FI SETUP"];
    
    NSArray *nameArr = @[@"PAIR DOOR CAMERA WITH WI-FI",@"CONNECT TO NETWORK VIA ETHERNET",@"SCAN QR CODE"];
    for(int i=0;i<3;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10, 64+30+60*i, lScreenWidth-20, 50);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [self.view addSubview:button];
    }
    
    UIImageView *code = [[UIImageView alloc]initWithFrame:CGRectMake((lScreenWidth-20)/2+80,  64+30+60*2+5, 40, 40)];
    code.image = [UIImage imageNamed:@"CODE"];
    [self.view addSubview:code];
}

- (void)buttonClicked:(UIButton *)button{
    
}

@end
