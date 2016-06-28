//
//  AddDetailViewController.m
//  P2PCamera
//
//  Created by Raindy on 16/3/3.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "AddDetailViewController.h"

@interface AddDetailViewController ()

@property (nonatomic,strong)UIView *myView;

@end

@implementation AddDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setupUI
{
    [self setMyNavBar];
//    self.navBar.backgroundColor = [UIColor blackColor];
    [self showRightButton];
    [self showLeftButton];
    [self.rightButton setTitle:@"存储" forState:UIControlStateNormal];
    self.titleLabel.text = @"新增摄影机";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0];
    [self setSubview];
    [self.view addSubview:self.myView];
}

- (void)setSubview{
    NSArray *arr = @[@"名称",@"UID",@"密码"];
    NSArray *arrPl = @[@"",@"摄影机UID",@"摄影机密码"];
    for (NSInteger i = 0; i<arr.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10*AUTO_WIDTH, 10*AUTO_HEIGHT+40*AUTO_HEIGHT*i, 40*AUTO_WIDTH, 20*AUTO_HEIGHT)];
        label.font = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = arr[i];
        label.textColor = [UIColor blackColor];
        [self.myView addSubview:label];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(130*AUTO_WIDTH, 10*AUTO_HEIGHT+40*AUTO_HEIGHT*i, 170*AUTO_WIDTH, 20*AUTO_HEIGHT)];
        textField.placeholder = arrPl[i];
        if (i == 0) {
            textField.text = @"摄影机";
            textField.clearButtonMode = UITextFieldViewModeAlways;
        }
        [self.myView addSubview:textField];
    }
}

- (UIView *)myView{
    if (!_myView) {
        _myView = [[UIView alloc]initWithFrame:CGRectMake(0, 100*AUTO_HEIGHT, SCREEN_WIDTH, 120*AUTO_HEIGHT)];
        _myView.backgroundColor = [UIColor whiteColor];
    }
    return _myView;
}



@end
