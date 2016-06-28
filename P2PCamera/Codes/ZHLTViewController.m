//
//  ZHLTViewController.m
//  G1APP
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 ZHLT. All rights reserved.
//

#import "ZHLTViewController.h"
#import "ZHLTTabBar.h"
#import "BasicDefinetion.h"
@interface ZHLTViewController ()

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation ZHLTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirst = YES;
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIView *btn in self.tabBar.subviews) {
        if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            btn.hidden = YES;
        }
    }
    if (_isFirst) {
        _isFirst = NO;
        CGFloat btnWidth = self.view.bounds.size.width / self.viewControllers.count;
        
        for (int i=0; i<self.viewControllers.count; i++) {
            UINavigationController *nav = self.viewControllers[i];
            UIViewController       *vc = nav.viewControllers[0];
            
            ZHLTTabBar *btn = [ZHLTTabBar buttonWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, 49) title:vc.tabBarItem.title normalImage:vc.tabBarItem.image selectedImage:vc.tabBarItem.selectedImage];
            [btn setBackgroundColor:[UIColor blackColor]];
            [btn addTarget:self action:@selector(tabBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2000+i;
            [self.tabBar addSubview:btn];
            
            if (i == self.selectedIndex) {
                btn.selected = YES;
            }
        }
    }
}

- (void)tabBarBtnClicked:(ZHLTTabBar *)btn
{
    ZHLTTabBar *currentSelectedBtn = (ZHLTTabBar *)[self.tabBar viewWithTag:2000+self.selectedIndex];
    if (btn != currentSelectedBtn) {
        currentSelectedBtn.selected = NO;
        btn.selected = YES;
        
        self.selectedIndex = btn.tag - 2000;
    }
}



@end
