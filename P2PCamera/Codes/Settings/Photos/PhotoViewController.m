//
//  PhotoViewController.m
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (nonatomic,strong) UIView *video;
@property (nonatomic,strong) UIImageView *voice;
@property (nonatomic,strong) UIImageView *camera;
@property (nonatomic,strong) UIImageView *lock;

@end

@implementation PhotoViewController

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

- (void)setupUI{
    [self setTitleText:@"SAVED IMAGES"];
    _video = [[UIView alloc]initWithFrame:CGRectMake(10, 64+30, lScreenWidth-20, (lScreenWidth-20)/480*320)];
    _video.backgroundColor = [UIColor whiteColor];
    _video.layer.borderWidth = 1;
    _video.layer.borderColor = [UIColor blackColor].CGColor;
    
    _camera = [[UIImageView alloc]initWithFrame:CGRectMake(10+(lScreenWidth-20)/3, (lScreenWidth-20)/480*320+50+30+64, (lScreenWidth-20)/3, 80)];
    _camera.image = [UIImage imageNamed:@"trash_1"];
    _camera.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cameraButton)];
    [_camera addGestureRecognizer:tap5];
    _camera.userInteractionEnabled = YES;
    
    _voice = [[UIImageView alloc]initWithFrame:CGRectMake(10, (lScreenWidth-20)/480*320+50+30+64, (lScreenWidth-20)/3, 80)];
    _voice.image = [UIImage imageNamed:@"icon_left"];
    _voice.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(voiceButton)];
    [_voice addGestureRecognizer:tap3];
    _voice.userInteractionEnabled = YES;
    
    _lock = [[UIImageView alloc]initWithFrame:CGRectMake(10+2*(lScreenWidth-20)/3, (lScreenWidth-20)/480*320+50+30+64, (lScreenWidth-20)/3, 80)];
    _lock.image = [UIImage imageNamed:@"icon_right"];
    _lock.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lockButton)];
    [_lock addGestureRecognizer:tap4];
    _lock.userInteractionEnabled = YES;
    
    [self.view addSubview:_camera];
    [self.view addSubview:_video];
    [self.view addSubview:_lock];
    [self.view addSubview:_voice];
}

- (void)voiceButton {
    
}

- (void)cameraButton {
    
}

- (void)lockButton {
    
}


@end
