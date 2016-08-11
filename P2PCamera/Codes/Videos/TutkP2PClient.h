

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
-(void) listWifiAp;
-(void) setWifi:(IpcWifiAp) ap;
-(void)setPassword:(NSString *) oldPasswd : (NSString *) newPasswd;
-(void)setVideoMode:(int) video_mod; // 0 倒转, 1 镜像 , 3 倒转和镜像
- (void)lock_unlock:(int)lockIndex status:(BOOL)status;//加锁解锁
@property (nonatomic,retain) id delegate;
@end