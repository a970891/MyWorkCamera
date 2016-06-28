//
//  SetViewController.m
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "SetViewController.h"
#import "AccountSettingsViewController.h"
#import "RingTonesViewController.h"
#import "KeyViewController.h"
#import "PhotoViewController.h"
#import "WIFIViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

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
    [self setTitleText:@"SETTINGS"];

    NSArray *pics = @[@"settings_1",@"rongtone_1",@"key_1",@"photos_1",@"wifi_1",@"exit_1"];
    NSArray *nameArr = @[@"ACCOUNT SETTINGS",@"RINGTONE & NOTIFICATIONS",@"ASSIGN E-KEYS",@"VIEW STORED PHOTOS",@"Wi-Fi SETUP",@"EXIT APPLICATION"];
    for(int i=0;i<6;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10, 64+30+60*i, lScreenWidth-20, 50);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(12, 64+30+60*i+2, 46, 46)];
        image.image = [UIImage imageNamed:pics[i]];
        image.backgroundColor = [UIColor whiteColor];
        image.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.view addSubview:image];
        [self.view addSubview:button];
    }
}

- (void)buttonClicked:(UIButton *)button{
    self.navigationController.hidesBottomBarWhenPushed = YES;
    if (button.tag == 100) {
        [self.navigationController pushViewController:[[AccountSettingsViewController alloc]init] animated:YES];
    }
    if (button.tag == 101) {
        [self.navigationController pushViewController:[[RingTonesViewController alloc]init] animated:YES];
    }
    if (button.tag == 102) {
        [self.navigationController pushViewController:[[KeyViewController alloc]init] animated:YES];
    }
    if (button.tag == 103) {
        [self.navigationController pushViewController:[[PhotoViewController alloc]init] animated:YES];
    }
    if (button.tag == 104) {
        [self.navigationController pushViewController:[[WIFIViewController alloc]init] animated:YES];
    }
    if (button.tag == 105) {
        
    }
}

@end
