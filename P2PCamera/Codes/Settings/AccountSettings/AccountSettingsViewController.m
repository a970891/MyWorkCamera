//
//  AccountSettingsViewController.m
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "AccountSettingsViewController.h"

@interface AccountSettingsViewController ()

@end

@implementation AccountSettingsViewController

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
    [self setTitleText:@"ACCOUNT SETTINGS"];
    
    NSArray *nameArr = @[@"ENTER EMAIL ACCOUNTS",@"ADD USERS",@"PREVIEW & MODIFY USERS",@"CREATE PREMISSIONS_ASSIGN ADMINISTRATOR",@"MODIFY PASSWORD"];
    for(int i=0;i<5;i++){
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
}

- (void)buttonClicked:(UIButton *)button{
    
}

@end
