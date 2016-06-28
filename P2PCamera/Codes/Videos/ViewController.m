

#import "ViewController.h"
#import "AAPLEAGLLayer.h"
#import "TutkP2pClient.h"
#import "DecodeH264.h"
#import "Yp420PixelConverter.h"
#import "OpenALPlayer.h"

@interface ViewController ()<UICollectionViewDelegate>
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
@end



@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    player = [[OpenALPlayer alloc] init];
    isInitAlPlayer=NO;
    
    //@"FZJ9AENPYXUP8NPPYZW1" :@"admin"
    
    //uid=@"TNV3SSYCSZ26PPNZ111A";
    //uid=@"TL4U31LKDP1U9R3R111A";
    
    //passwd=@"123456";
    //uid=@"L9WJBX31BXRMLAF3111A";
    NSString *uid1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    uid= uid1;
    passwd=@"admin123";
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    yp420PixelConverter=[[Yp420PixelConverter alloc] init];
    
    
    //cameraView1=[[UIView alloc] initWithFrame:self];
    
    //[self.view addSubview:cameraView1];
    
    _glLayer = [[AAPLEAGLLayer alloc] initWithFrame:self.view.bounds];
    [self.view.layer addSublayer:_glLayer];
    //audio_player= [[OpenALPlayer alloc] init];
    //
    
    
    tutkP2PAVClient=[[TutkP2PAVClient alloc] init];
    _decodeH264=[[DecodeH264 alloc] init];
    _decodeH264.delegate=self;
    
    tutkP2PAVClient.delegate=self;
    //[tutkP2PAVClient connect:uid :passwd];
    //[tutkP2PAVClient listWifiAp];
    int ret=[tutkP2PAVClient start:uid :passwd];
    
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
