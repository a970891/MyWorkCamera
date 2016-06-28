//
//  CameraViewController.m
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "CameraViewController.h"
#import "AAPLEAGLLayer.h"
#import "TutkP2pClient.h"
#import "DecodeH264.h"
#import "Yp420PixelConverter.h"
#import "OpenALPlayer.h"
#import "CameraObject.h"
#import "SVProgressHUD.h"

@interface CameraViewController () <UICollectionViewDelegate>

{
    DecodeH264 *_decodeH264;
    AAPLEAGLLayer *_glLayer;
    Yp420PixelConverter *yp420PixelConverter;
    
    TutkP2PAVClient *tutkP2PAVClient;
    BOOL isInitAlPlayer;
    
    OpenALPlayer *player;
    
    NSString *uid;
    NSString *passwd;
}

@property (nonatomic,copy) NSString *kUid;
@property (nonatomic,copy) NSString *password;

@property (nonatomic,strong) UIView *video;
@property (nonatomic,strong) UISlider *slider;

@property (nonatomic,strong) UIImageView *voice;
@property (nonatomic,strong) UIImageView *camera;
@property (nonatomic,strong) UIImageView *lock;

@end

@implementation CameraViewController

- (CameraViewController *)initWithUid:(NSString *)uid password:(NSString *)password {
    self = [super init];
    self.kUid = uid;
    self.password = password;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSetupUI];
    [self initNaviTools];
    [self setupUI];
    [self setupCamera];
}

- (void)setupCamera {
    player = [[OpenALPlayer alloc] init];
    isInitAlPlayer=NO;
    
    
    uid = self.kUid;
    passwd = self.password;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
     
                                               object:nil];
    
    yp420PixelConverter=[[Yp420PixelConverter alloc] init];
    
    _glLayer = [[AAPLEAGLLayer alloc] initWithFrame:self.video.bounds];
    [self.video.layer addSublayer:_glLayer];
    
    
    tutkP2PAVClient=[[TutkP2PAVClient alloc] init];
    _decodeH264=[[DecodeH264 alloc] init];
    _decodeH264.delegate=self;
    
    tutkP2PAVClient.delegate=self;
    int ret=[tutkP2PAVClient start:uid :passwd];

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
    [self setTitleText:@"camera"];
    _video = [[UIView alloc]initWithFrame:CGRectMake(10, 64+30, lScreenWidth-20, (lScreenWidth-20)/480*320)];
    _video.backgroundColor = [UIColor whiteColor];
    _video.layer.borderWidth = 1;
    _video.layer.borderColor = [UIColor blackColor].CGColor;
    
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(10+30, 64+30+15+_video.frame.size.height, lScreenWidth-80, 15)];
    UIImageView *reduce = [[UIImageView alloc]initWithFrame:CGRectMake(10, _slider.frame.origin.y-7, 30, 30)];
    reduce.layer.cornerRadius = 15;
    reduce.clipsToBounds = YES;
    reduce.image = [UIImage imageNamed:@"reduce"];
    reduce.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reduce)];
    [reduce addGestureRecognizer:tap1];
    reduce.userInteractionEnabled = YES;
    
    UIImageView *plus = [[UIImageView alloc]initWithFrame:CGRectMake(lScreenWidth-40, _slider.frame.origin.y-7, 30, 30)];
    plus.image = [UIImage imageNamed:@"plus"];
    plus.backgroundColor = [UIColor blackColor];
    plus.layer.cornerRadius = 15;
    plus.clipsToBounds = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(plus)];
    [plus addGestureRecognizer:tap2];
    plus.userInteractionEnabled = YES;
    
    _voice = [[UIImageView alloc]initWithFrame:CGRectMake(10, _slider.frame.origin.y+50, (lScreenWidth-20)/3, 80)];
    _voice.image = [[UIImage imageNamed:@"voice"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _voice.tintColor = [UIColor lightGrayColor];
    _voice.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(voiceButton)];
    [_voice addGestureRecognizer:tap3];
    _voice.userInteractionEnabled = YES;

    _lock = [[UIImageView alloc]initWithFrame:CGRectMake(10+2*(lScreenWidth-20)/3, _slider.frame.origin.y+50, (lScreenWidth-20)/3, 80)];
    _lock.image = [[UIImage imageNamed:@"lock"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _lock.tintColor = [UIColor lightGrayColor];
    _lock.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lockButton)];
    [_lock addGestureRecognizer:tap4];
    _lock.userInteractionEnabled = YES;
    
    _camera = [[UIImageView alloc]initWithFrame:CGRectMake(10+(lScreenWidth-20)/3, _slider.frame.origin.y+50, (lScreenWidth-20)/3, 80)];
    _camera.image = [[UIImage imageNamed:@"camera"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _camera.contentMode = UIViewContentModeScaleAspectFit;
    _camera.tintColor = [UIColor lightGrayColor];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cameraButton)];
    [_camera addGestureRecognizer:tap5];
    _camera.userInteractionEnabled = YES;
    
    UIView *lineA = [[UIView alloc]initWithFrame:CGRectMake(10, _slider.frame.origin.y+40, lScreenWidth-20, 2*_px)];
    lineA.backgroundColor = [UIColor whiteColor];

    UIView *lineB = [[UIView alloc]initWithFrame:CGRectMake(10, _slider.frame.origin.y+145, lScreenWidth-20, 2*_px)];
    lineB.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:lineA];
    [self.view addSubview:lineB];
    [self.view addSubview:_voice];
    [self.view addSubview:_lock];
    [self.view addSubview:_camera];
    [self.view addSubview:plus];
    [self.view addSubview:reduce];
    [self.view addSubview:_slider];
    [self.view addSubview:_video];
    
    
    float w = lScreenWidth-20;
    float h = (lScreenWidth-20)/480*320;
    UIView *up = [[UIView alloc]initWithFrame:CGRectMake(40, 0, w-80, 40)];
    up.backgroundColor = [UIColor clearColor];
    up.userInteractionEnabled = true;
    up.tag = 51;
    UITapGestureRecognizer *tap11 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(turn:)];
    [up addGestureRecognizer:tap11];
    UIView *down = [[UIView alloc]initWithFrame:CGRectMake(40, h-40, w-80, 40)];
    down.backgroundColor = [UIColor clearColor];
    down.userInteractionEnabled = true;
    down.tag = 52;
    UITapGestureRecognizer *tap22 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(turn:)];
    [down addGestureRecognizer:tap22];
    UIView *left = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 40, h-80)];
    left.backgroundColor = [UIColor clearColor];
    left.userInteractionEnabled = true;
    left.tag = 53;
    UITapGestureRecognizer *tap33 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(turn:)];
    [left addGestureRecognizer:tap33];
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(0, h-40, 40, h-80)];
    right.backgroundColor = [UIColor clearColor];
    right.userInteractionEnabled = true;
    right.tag = 54;
    UITapGestureRecognizer *tap44 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(turn:)];
    [right addGestureRecognizer:tap44];
    
    [_video addSubview:up];
    [_video addSubview:down];
    [_video addSubview:left];
    [_video addSubview:right];
}

- (void)turn:(UITapGestureRecognizer *)tap {
    NSInteger i = tap.view.tag - 50;
    if (i == 1) {
        [tutkP2PAVClient turn:1];
    }
    if (i == 2) {
        [tutkP2PAVClient turn:0];
    }
    if (i == 3) {
        [tutkP2PAVClient turn:2];
    }
    if (i == 4) {
        [tutkP2PAVClient turn:3];
    }
}

- (void)reduce {
    _slider.value = _slider.value - 0.1;
}

- (void)plus {
    _slider.value = _slider.value + 0.1;
}

- (void)voiceButton {
     [SVProgressHUD showErrorWithStatus:@"功能暂未开放"];
}

- (void)cameraButton {
    [SVProgressHUD showWithStatus:@"保存中"];
    //获取屏幕图像
    UIGraphicsBeginImageContext(_glLayer.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_glLayer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //保存到相册
    [self saveImageToPhotos:theImage];
}

- (void)lockButton {
    [SVProgressHUD showErrorWithStatus:@"功能暂未开放"];
}

- (void)saveImageToPhotos:(UIImage*)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功"];
    }
}

- (void)leftButtonAction {
    [tutkP2PAVClient stopAndCloseSession];
    [self.navigationController popViewControllerAnimated:true];
}

//#=====================TutkP2PAVClientDelegate==============
-(void)onReceivedIFrame:(uint8_t*) data : (int) length{
    
    uint8_t *pByte = malloc(length);
    memcpy(pByte, data, length);
    [_decodeH264 decode:pByte :length];
    free(pByte);
}
-(void)onReceivedBPFrame:(uint8_t*) data : (int) length{
    
    uint8_t *pByte = malloc(length);
    memcpy(pByte, data, length);
    [_decodeH264 decode:pByte :length];
    free(pByte);
    
    
}
-(void)onReceivedAudio:(char*) data : (int) length : (unsigned int) rate : (unsigned int)format{
    if(isInitAlPlayer==NO){
        isInitAlPlayer=YES;
        [player initOpenAL:format :rate];
    }
    [player openAudioFromQueue:[NSData dataWithBytes:data length:length]];
}


-(void)onConnectionFail:(NSString*) error{
    
}

//#======================END TutkP2PAVClientDelegate==============

//#=====================decodeH264Delegate===================
-(void)onDecodeComplete:(CVPixelBufferRef) pixelBuffer{
    //CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    //UIImage *uiImage = [UIImage imageWithCIImage:ciImage];
    
    //NSData *imgData=[yp420PixelConverter toNSData:pixelBuffer];
    _glLayer.pixelBuffer = pixelBuffer;
}

-(void)onListWifiAp:(NSMutableArray *) aps{
    [tutkP2PAVClient closeSession];
    [NSThread sleepForTimeInterval:5];
    for(NSValue *obj in aps){
        IpcWifiAp ap;
        [obj getValue:&ap];
        NSLog(@"%s",ap.ssid);
        
    }
}

//#======================end  decodeH264Delegate=================================

//#======================= start UICollectionViewDelegate===================
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"去后台");
    [tutkP2PAVClient stopAndCloseSession];
    [_decodeH264 clearH264Deocder];
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"去前台1");
    int ret=[tutkP2PAVClient start:uid :passwd];
    _decodeH264=[[DecodeH264 alloc] init];
    _decodeH264.delegate=self;
}

//#========================end UICollectionViewDelegate=====================


@end
