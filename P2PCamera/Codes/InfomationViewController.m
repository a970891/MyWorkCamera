//
//  InfomationViewController.m
//  P2PCamera
//
//  Created by Raindy on 16/3/1.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "InfomationViewController.h"
#import "P2PCamera-Swift.h"

@interface InfomationViewController ()

@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *label;

@end

@implementation InfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    [self setMyNavBar];
    self.titleLabel.text = NSLocalizedString(@"title_info", @"");
    self.view.backgroundColor = [UIColor whiteColor];
    
    _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake((lScreenWidth-120)/2, 100, 120, 120)];
    _iconImage.image = [UIImage imageNamed:@"120"];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 240, lScreenWidth, 20)];
    _label.textColor = [UIColor lightGrayColor];
    _label.text = NSLocalizedString(@"info_appV", @"");
    _label.font = [UIFont systemFontOfSize:15];
    _label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:_iconImage];
    [self.view addSubview:_label];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
