

typedef  void(^SUCCESS_BLOCK)(void);
typedef  void(^FAIL_BLOCK)(void);

typedef enum
{
    IOCTRL_U=0,
    IOCTRL_D=1,
    IOCTRL_L=2,
    IOCTRL_R=3
    
}ENUM_TURN_CMD;

typedef struct
{
    char ssid[32]; 				// WiFi ssid
    char mode;	   				// refer to ENUM_AP_MODE
    char enctype;  				// refer to ENUM_AP_ENCTYPE
    char signal;   				// signal intensity 0--100%
    char status;   				// 0 : invalid ssid or disconnected
    char passwd[64];            //WIFI password
}IpcWifiAp;

typedef void (^SearchBlock)(NSString *str);

@protocol CameraInfoDelegate <NSObject>

- (void)receiveWifi:(NSArray *)ssids modes:(NSArray *)modes types:(NSArray *)types;
- (void)receiveVideoMode:(int)mode;
- (void)receiveEnvironmentMode:(int)mode;
- (void)receiveEXTSdCardResult:(int)result;
- (void)receiveMotionDetect:(int)detect;
- (void)receiveDeviceInfo:(int)type content:(NSString *)content;
- (void)receiveQuality:(int)quality;
- (void)receiveRecordType:(int)type;

@end

@protocol TutkP2PAVClientDelegate<NSObject>
-(void)onReceivedIFrame:(uint8_t*) data : (int) length;
-(void)onReceivedBPFrame:(uint8_t*) data : (int) length;
-(void)onReceivedAudio:(char*) data : (int) length : (unsigned int) rate : (unsigned int)format;
-(void)onConnectionFail:(NSString*) error;
@end

@interface TutkP2PAVClient : NSObject

@property (nonatomic,copy) NSString *UID;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,assign) int SID;
@property (nonatomic,assign) int avIndex;

//初始化
+(int) initializeTutk;
//释放
+(void)releaseTutk;
//连接并播放
-(void)startAndPlayAVsuccess:(SUCCESS_BLOCK)succeed fail:(FAIL_BLOCK)failed;
//连接
-(void) connectsuccess:(SUCCESS_BLOCK)succeed fail:(FAIL_BLOCK)failed;
//关闭线程
-(void) stopAndCloseSession;
//关闭视频和音频
- (void)closeAV;
//搜索摄像头
- (void)SearchAndConnect:(SearchBlock)searchBlock;
//获取wifi
-(int)listWifiAp;
//获取显示模式
-(int)getVideoMode;
//获取环境模式
-(int)getEnvironmentMode;
//获取移动侦测
-(int)getMotionDetect;
//获取设备信息
-(int)getDeviceInfo;
//格式化SD卡
-(int)getStorage;
//获取视频质量
-(int)getVideoQuality;
//获取录像模式
-(int)getRecordMode;

//设置wifi
- (int)setWifi:(NSString *)ssid pwd:(NSString *)pswd mode:(NSString *)mode type:(NSString *)type;
//设置密码
- (int)setPassword:(NSString *)oldPasswd :(NSString *)newPasswd;
//设置显示模式
- (int)setVideoMode:(int)video_mod;
//设置环境模式
- (int)setEnvironmentMode:(int)mode;
//设置移动侦测
- (int)setMotionDetece:(int)mode;
//设置录像模式
- (int)setRecordMode:(int)mode;
//设置视频质量
-(int)setQuality:(int)quality;
//设置禁音
- (int)setMute:(BOOL)on;
//对讲
- (int)sendVoice:(BOOL)on;

- (void)lock_unlock:(int)lockIndex status:(BOOL)status;//加锁解锁
@property (nonatomic,retain) id delegate;
@property (nonatomic,retain) id<CameraInfoDelegate> infoDelegate;
@end