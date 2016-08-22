

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

@protocol CameraInfoDelegate <NSObject>

- (void)receiveWifi;
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
-(void)onListWifiAp:(NSMutableArray *) aps;
@end

@interface TutkP2PAVClient : NSObject
+(int) initializeTutk;
+(void)releaseTutk;
-(int) start:(NSString *) UID : (NSString *) password;
-(int) connect:(NSString *) UID : (NSString *) password;
-(void) stopAndCloseSession;
-(int) closeSession;
-(void) turn:(ENUM_TURN_CMD)direction;

-(void) setWifi:(IpcWifiAp) ap;
-(void)setPassword:(NSString *) oldPasswd : (NSString *) newPasswd;
-(void)setVideoMode:(int) video_mod; // 0 倒转, 1 镜像 , 3 倒转和镜像
//获取wifi
-(void)listWifiAp;
//获取显示模式
-(int)getVideoMode;
//获取环境模式
-(int)getEnvironmentMode;
//获取移动侦测
-(int)getMotionDetect;
//获取录像模式
-(int)getDeviceInfo;
//格式化SD卡
-(int)getStorage;
//获取视频质量
-(int)getVideoQuality;
//获取录像模式
-(int)getRecordMode;

- (void)lock_unlock:(int)lockIndex status:(BOOL)status;//加锁解锁
@property (nonatomic,retain) id delegate;
@property (nonatomic,retain) id<CameraInfoDelegate> infoDelegate;
@end