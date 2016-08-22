
#import <Foundation/Foundation.h>
#import "TutkP2PClient.h"
#import "IOTCAPIs.h"
#import "AVAPIs.h"
#import "AVIOCTRLDEFs.h"
#import "AVFRAMEINFO.h"
#import <sys/time.h>
#import "g711codec.h"
#import "OpenALPlayer.h"

#define PT_SPEED 8
#define AUDIO_BUF_SIZE	1024
#define VIDEO_BUF_SIZE	2000000

@implementation TutkP2PAVClient{
    int avIndex,SID,stopFlg;
}
@synthesize delegate;

+(int) initializeTutk{
    long _tickCount=[self getTickCount];
    unsigned short nUdpPort = (unsigned short)(10000 + _tickCount % 10000);
    int ret;
    ret = IOTC_Initialize(nUdpPort, "50.19.254.134", "122.248.234.207", "m4.iotcplatform.com", "m5.iotcplatform.com");
    NSLog(@"IOTC_Initialize() ret = %d", ret);
    
    if (ret != IOTC_ER_NoERROR) {
        NSLog(@"IOTCAPIs exit...");
        return -1;
    }
    // alloc 4 sessions for video and two-way audio
    avInitialize(4);
    return ret;
}

+(void)releaseTutk{
    avDeInitialize();
    IOTC_DeInitialize();
}

-(int) recv_io_ctrl_loop {
    
    while (stopFlg) {
        unsigned int ioType;
        char trash[1500];
        int ret = avRecvIOCtrl(avIndex, &ioType, trash, sizeof(trash), 10000);
        if(ret < 0) {
            printf("avRecvIOCtrl[%d][%d]\n", ret, avIndex);
            break;
        }else {
            switch (ioType) {
                case IOTYPE_USER_IPCAM_LISTWIFIAP_RESP:;
                    SMsgAVIoctrlListWifiApResp *wifiList = (SMsgAVIoctrlListWifiApResp *)trash;
                    [self.infoDelegate receiveWifi:[NSString stringWithFormat:@"%s",wifiList->stWifiAp->ssid]];
                    break;
                case IOTYPE_USER_IPCAM_SETWIFI_RESP:;
                    //SMsgAVIoctrlSetWifiResp *reponse=(SMsgAVIoctrlSetWifiResp*)trash;
                    //[self handSetWifiResp:reponse];
                    break;
                //获取视频模式
                case IOTYPE_USER_IPCAM_GET_VIDEOMODE_RESP:;
                    SMsgAVIoctrlGetVideoModeResp *response = (SMsgAVIoctrlGetVideoModeResp *)trash;
                    switch (response->mode) {
                        case AVIOCTRL_VIDEOMODE_NORMAL:
                            NSLog(@"正常");
                            [self.delegate receiveVideoMode:0];
                            break;
                        case AVIOCTRL_VIDEOMODE_FLIP:
                            NSLog(@"翻转");
                            [self.delegate receiveVideoMode:1];
                            break;
                        case AVIOCTRL_VIDEOMODE_MIRROR:
                            [self.delegate receiveVideoMode:2];
                            NSLog(@"镜像");
                            break;
                        case AVIOCTRL_VIDEOMODE_FLIP_MIRROR:
                            [self.delegate receiveVideoMode:3];
                            NSLog(@"翻转镜像");
                            break;
                        default:
                            [self.delegate receiveVideoMode:-1];
                            break;
                    }
                    break;
                //获取环境模式
                case IOTYPE_USER_IPCAM_GET_ENVIRONMENT_RESP:;
                    SMsgAVIoctrlGetEnvironmentResp *environment = (SMsgAVIoctrlGetEnvironmentResp *)trash;
                    switch (environment->mode) {
                        case AVIOCTRL_ENVIRONMENT_INDOOR_50HZ:
                            [self.delegate receiveEnvironmentMode:0];
                            NSLog(@"室内50HZ模式");
                            break;
                        case AVIOCTRL_ENVIRONMENT_INDOOR_60HZ:
                            [self.delegate receiveEnvironmentMode:1];
                            NSLog(@"室内60HZ模式");
                            break;
                        case AVIOCTRL_ENVIRONMENT_OUTDOOR:
                            [self.delegate receiveEnvironmentMode:2];
                            NSLog(@"室外模式");
                            break;
                        case AVIOCTRL_ENVIRONMENT_NIGHT:
                            [self.delegate receiveEnvironmentMode:3];
                            NSLog(@"夜间模式");
                            break;
                        default:
                            [self.delegate receiveEnvironmentMode:-1];
                            break;
                    }
                    break;
                //获取移动侦测
                case IOTYPE_USER_IPCAM_GETMOTIONDETECT_RESP:;
                    SMsgAVIoctrlGetMotionDetectResp *motion = (SMsgAVIoctrlGetMotionDetectResp *)trash;
                    switch (motion->sensitivity) {
                        case 0:
                            NSLog(@"0");
                            [self.delegate receiveMotionDetect:0];
                            break;
                        case 1:
                            NSLog(@"25");
                            [self.delegate receiveMotionDetect:1];
                            break;
                        case 2:
                            NSLog(@"50");
                            [self.delegate receiveMotionDetect:2];
                            break;
                        case 3:
                            NSLog(@"75");
                            [self.delegate receiveMotionDetect:3];
                            break;
                        case 4:
                            NSLog(@"100");
                            [self.delegate receiveMotionDetect:4];
                            break;
                        default:
                            [self.delegate receiveMotionDetect:-1];
                            break;
                    }
                    break;
                //获取设备信息
                case IOTYPE_USER_IPCAM_DEVINFO_RESP:;
                    SMsgAVIoctrlDeviceInfoResp * info = (SMsgAVIoctrlDeviceInfoResp *)trash;
                    //型号model
                    [self.delegate receiveDeviceInfo:0 content:[NSString stringWithFormat:@"%s",info->model]];
                    //厂商
                    [self.delegate receiveDeviceInfo:1 content:[NSString stringWithFormat:@"%s",info->vendor]];
                    //版本号version
                    [self.delegate receiveDeviceInfo:2 content:[NSString stringWithFormat:@"%x",info->version]];
                    //总容量
                    [self.delegate receiveDeviceInfo:3 content:[NSString stringWithFormat:@"%d",info->total]];
                    //剩余容量
                    [self.delegate receiveDeviceInfo:4 content:[NSString stringWithFormat:@"%d",info->free]];
                    /*
                     unsigned char model[16];	// IPCam mode
                     unsigned char vendor[16];	// IPCam manufacturer厂商
                     unsigned int version;		// IPCam firmware version	ex. v1.2.3.4 => 0x01020304;  v1.0.0.2 => 0x01000002
                     unsigned int channel;		// Camera index
                     unsigned int total;			// 0: No cards been detected or an unrecognizeable sdcard that could not be re-formatted.
                     // -1: if camera detect an unrecognizable sdcard, and could be re-formatted
                     // otherwise: return total space size of sdcard (MBytes)
                     
                     unsigned int free;			// Free space size of sdcard (MBytes)
                     unsigned char reserved[8];	// reserved
                     */
                    break;
                case IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_RESP:;
                    SMsgAVIoctrlFormatExtStorageResp *result = (SMsgAVIoctrlFormatExtStorageResp *)trash;
                    switch (result->result) {
                        case 0:
                            NSLog(@"格式化成功");
                            [self.delegate receiveEXTSdCardResult:0];
                            break;
                        default:
                            NSLog(@"格式化失败");
                            [self.delegate receiveEXTSdCardResult:-1];
                            break;
                    }
                //获取视频质量
                case IOTYPE_USER_IPCAM_GETSTREAMCTRL_RESP:;
                    SMsgAVIoctrlGetStreamCtrlResq *quality = (SMsgAVIoctrlGetStreamCtrlResq *)trash;
                    switch (quality->quality) {
                        case AVIOCTRL_QUALITY_UNKNOWN:
                            NSLog(@"未知");
                            [self.delegate receiveQuality:-1];
                            break;
                        case AVIOCTRL_QUALITY_MAX:
                            NSLog(@"最高");
                            [self.delegate receiveQuality:0];
                            break;
                        case AVIOCTRL_QUALITY_HIGH:
                            NSLog(@"高");
                            [self.delegate receiveQuality:1];
                            break;
                        case AVIOCTRL_QUALITY_MIDDLE:
                            NSLog(@"中");
                            [self.delegate receiveQuality:2];
                            break;
                        case AVIOCTRL_QUALITY_LOW:
                            NSLog(@"低");
                            [self.delegate receiveQuality:3];
                            break;
                        case AVIOCTRL_QUALITY_MIN:
                            NSLog(@"最低");
                            [self.delegate receiveQuality:4];
                            break;
                        default:
                            [self.delegate receiveQuality:-1];
                            break;
                    }
                    break;
                //获取录像模式
                case IOTYPE_USER_IPCAM_GETRECORD_RESP:;
                    SMsgAVIoctrlGetRecordResq *record = (SMsgAVIoctrlGetRecordResq *)trash;
                    switch (record->recordType) {
                        case AVIOTC_RECORDTYPE_OFF:
                            [self.delegate receiveRecordType:0];
                            break;
                        case AVIOTC_RECORDTYPE_FULLTIME:
                            [self.delegate receiveRecordType:1];
                            break;
                        case AVIOTC_RECORDTYPE_ALARM:
                            [self.delegate receiveRecordType:2];
                            break;
                        case AVIOTC_RECORDTYPE_MANUAL:
                            [self.delegate receiveRecordType:3];
                        default:
                            [self.delegate receiveRecordType:-1];
                            break;
                    }
                default:;
            }
            
        }
    }
    return 1;
}

//获取Wifi信息
-(int)listWifiAp{
    int ret;
    
    SMsgAVIoctrlListWifiApReq request; //= (SMsgAVIoctrlListWifiApReq *)malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_LISTWIFIAP_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"list_wifi_ap_failed[%d]", ret);
        return -1;
    }
    //free(request);
    return 1;
}

//获取显示模式
-(int)getVideoMode{
    int ret;
    
    SMsgAVIoctrlListWifiApReq request; //= (SMsgAVIoctrlListWifiApReq *)malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_GET_VIDEOMODE_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"list_wifi_ap_failed[%d]", ret);
        return -1;
    }
    //free(request);
    return 1;
}
//获取环境模式
-(int)getEnvironmentMode{
    int ret;
    
    SMsgAVIoctrlGetEnvironmentReq request; //= (SMsgAVIoctrlListWifiApReq *)malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    request.channel = avIndex;
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_GET_ENVIRONMENT_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"list_wifi_ap_failed[%d]", ret);
        return -1;
    }
    //free(request);
    return 1;
}
//获取移动侦测
-(int)getMotionDetect{
    int ret;
    
    SMsgAVIoctrlGetMotionDetectReq request; //= (SMsgAVIoctrlListWifiApReq *)malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    request.channel = avIndex;
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_GETMOTIONDETECT_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"list_wifi_ap_failed[%d]", ret);
        return -1;
    }
    //free(request);
    return 1;
}
//获取设备信息
-(int)getDeviceInfo{
    int ret;
    
    SMsgAVIoctrlDeviceInfoReq request; //= (SMsgAVIoctrlListWifiApReq *)malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_DEVINFO_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"list_wifi_ap_failed[%d]", ret);
        return -1;
    }
    //free(request);
    return 1;
}
//格式化SD卡
-(int)getStorage{
    int ret;
    
    SMsgAVIoctrlFormatExtStorageReq request; //= (SMsgAVIoctrlListWifiApReq *)malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"list_wifi_ap_failed[%d]", ret);
        return -1;
    }
    //free(request);
    return 1;
}
//获取视频质量
-(int)getVideoQuality{
    int ret;
    
    SMsgAVIoctrlGetStreamCtrlReq request; //= (SMsgAVIoctrlListWifiApReq *)malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    request.channel = avIndex;
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_GETSTREAMCTRL_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"list_wifi_ap_failed[%d]", ret);
        return -1;
    }
    //free(request);
    return 1;
}
//获取录像模式
-(int)getRecordMode{
    int ret;
    
    SMsgAVIoctrlGetRecordReq request; //= (SMsgAVIoctrlListWifiApReq *)malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    request.channel = avIndex;
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_GETRECORD_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"list_wifi_ap_failed[%d]", ret);
        return -1;
    }
//    free(request);
    return 1;
}

/*************************************************************************/
/*************************      设置       *******************************/
/************************************************************************/

/*
 设置WIFI
 */
-(int) setWifi:(IpcWifiAp) ap{
    SMsgAVIoctrlSetWifiReq request; //= (SMsgAVIoctrlSetWifiReq *)malloc(sizeof(SMsgAVIoctrlSetWifiReq));
    strcpy((char *)request.ssid, ap.ssid);
    request.enctype=ap.enctype;
    request.mode=ap.mode;
    strcpy((char *)request.password, ap.passwd);
    NSLog(@"set wifi ssid=%s,password=%s,request.enctype=%d",request.ssid,request.password,request.enctype);
    int ret;
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_SETWIFI_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"set_wifi_ap_failed[%d]", ret);
        return -1;
    }
    return ret;
}
//设置密码
-(int)setPassword:(NSString *) oldPasswd : (NSString *) newPasswd{
    SMsgAVIoctrlSetPasswdReq request;
    strcpy(request.newpasswd, [newPasswd UTF8String]);
    strcpy(request.oldpasswd, [oldPasswd UTF8String]);
    int ret;
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_SETPASSWORD_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"set_ipc_password_failed[%d]", ret);
        return -1;
    }
    return ret;
}

// 0正常, 1 倒转 , 2镜像 , 3 倒转和镜像
-(int)setVideoMode:(int) video_mod{
    SMsgAVIoctrlSetVideoModeReq request;
    request.channel=avIndex;
    request.mode=video_mod;
    int ret;
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_SET_VIDEOMODE_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"set_video_mode_failed[%d]", ret);
        return -1;
    }
    return ret;
}
//设置环境模式
- (int)setEnvironmentMode:(int)mode{
    SMsgAVIoctrlSetEnvironmentReq request;
    request.channel=avIndex;
    request.mode=mode;
    int ret;
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_SET_ENVIRONMENT_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"set_video_mode_failed[%d]", ret);
        return -1;
    }
    return ret;
}
//设置视频质量
-(int)setQuality:(int)quality{
    SMsgAVIoctrlSetStreamCtrlReq request;
    request.channel=avIndex;
    request.quality=quality;
    int ret;
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_SETSTREAMCTRL_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"set_video_quality_failed[%d]", ret);
        return -1;
    }
    return ret;
}
//设置移动侦测
- (int)setMotionDetece:(int)mode{
    SMsgAVIoctrlSetMotionDetectReq request;
    request.channel = avIndex;
    request.sensitivity = mode;
    
    int ret;
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_SETMOTIONDETECT_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"set_video_quality_failed[%d]", ret);
        return -1;
    }
    return ret;
}
//设置录像模式
- (int)setRecordMode:(int)mode{
    SMsgAVIoctrlSetRecordReq request;
    request.channel = avIndex;
    request.recordType = mode;
    
    int ret;
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_SETRECORD_REQ, (char *)&request, sizeof(request)) < 0))
    {
        NSLog(@"set_video_quality_failed[%d]", ret);
        return -1;
    }
    return ret;
}
//设置禁音
- (int)setMute:(BOOL)on{
    SMsgAVIoctrlAVStream request;
    request.channel = avIndex;
    int ret;
    
    if (on) {
        if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_AUDIOSTART, (char *)&request, sizeof(request)) < 0))
        {
            NSLog(@"set_video_quality_failed[%d]", ret);
            return -1;
        }
    } else {
        if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_AUDIOSTOP, (char *)&request, sizeof(request)) < 0))
        {
            NSLog(@"set_video_quality_failed[%d]", ret);
            return -1;
        }
    }
    
    return 1;
}
//对讲
- (int)sendVoice:(BOOL)on{
    SMsgAVIoctrlAVStream request;
    request.channel = avIndex;
    int ret;
    
    if (on) {
        if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_SPEAKERSTART, (char *)&request, sizeof(request)) < 0))
        {
            NSLog(@"set_video_quality_failed[%d]", ret);
            return -1;
        }
    } else {
        if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_SPEAKERSTOP, (char *)&request, sizeof(request)) < 0))
        {
            NSLog(@"set_video_quality_failed[%d]", ret);
            return -1;
        }
    }
    
    return 1;
}

/*
 -(void) handSetWifiResp:(SMsgAVIoctrlSetWifiResp *) reponse{
 NSLog(@"Tutk set wifi resp=%d",reponse->result);
 if(delegate !=nil){
 BOOL rs=YES;
 if(reponse->result!=0){
 rs=NO;
 }
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 [delegate onReceivedSetWifiResp:rs];
 });
 
 }
 }
 */
-(void) handListWifiAPReponse:(SMsgAVIoctrlListWifiApResp*) wifiList{
    NSMutableArray *ssidArray = [NSMutableArray array];
    for(int i=0;i<sizeof(wifiList->stWifiAp);i++){
        SWifiAp ap=wifiList->stWifiAp[i];
        NSLog(@"ssid=%s,mode=%d=",ap.ssid,ap.mode);
        if((ap.mode==1 || ap.mode==2) && strlen(ap.ssid)>1){
            BOOL isFind=NO;
            for(NSValue *obj in ssidArray){
                IpcWifiAp tmap;
                [obj getValue:&tmap];
                if(strcmp(ap.ssid,tmap.ssid)==0){
                    isFind=YES;
                    break;
                }
            }
            if(isFind==NO){
                IpcWifiAp ipcAp={"", ap.mode,ap.enctype,ap.signal,ap.status};
                memcpy(ipcAp.ssid, (char *)&ap.ssid, 32);
                [ssidArray addObject:[NSValue valueWithBytes:&ipcAp objCType:@encode(IpcWifiAp)]];
            }
        }
    }
    
    if(delegate !=nil){
        dispatch_async(dispatch_queue_create("onListWifiApThreadQueue", DISPATCH_QUEUE_SERIAL), ^{
            if ([delegate respondsToSelector:@selector(onListWifiAp:)]) {
                [delegate onListWifiAp:ssidArray];
            }
            
        });
        
    }
}

-(int) connect:(NSString *) UID : (NSString *) password{
    NSLog(@"uid=%@,AVStream Client Starting...",UID);
    
    int ret;
    // use IOTC_Connect_ByUID or IOTC_Connect_ByName to connect with device
    
    //NSString *aesString = @"your aes key";
    
    SID = IOTC_Connect_ByUID((char *)[UID UTF8String]);
    
    printf("Step 2: call IOTC_Connect_ByUID2(%s) ret(%d).......\n", [UID UTF8String], SID);
    struct st_SInfo Sinfo;
    ret = IOTC_Session_Check(SID, &Sinfo);
    
    if (ret >= 0)
    {
        if(Sinfo.Mode == 0)
            printf("Device is from %s:%d[%s] Mode=P2P\n",Sinfo.RemoteIP, Sinfo.RemotePort, Sinfo.UID);
        else if (Sinfo.Mode == 1)
            printf("Device is from %s:%d[%s] Mode=RLY\n",Sinfo.RemoteIP, Sinfo.RemotePort, Sinfo.UID);
        else if (Sinfo.Mode == 2)
            printf("Device is from %s:%d[%s] Mode=LAN\n",Sinfo.RemoteIP, Sinfo.RemotePort, Sinfo.UID);
    }
    
    unsigned int srvType;
    avIndex = avClientStart(SID, "admin", [password UTF8String], 20000, &srvType, 0);
    printf("Step 3: call avClientStart(%d).......\n", avIndex);
    
    if(avIndex < 0)
    {
        printf("avClientStart failed[%d]\n", avIndex);
        return -1;
    }
    dispatch_async(dispatch_queue_create("recvIoResponseThreadQueue", DISPATCH_QUEUE_SERIAL), ^{
        [self recv_io_ctrl_loop];
    });
    stopFlg=1;
    return  ret;
}
-(int)start:(NSString *)UID :(NSString *)password{
    if([self connect:UID :password]<0){
        NSLog(@"Connect ipc fail");
        return -1;
    }
    if ([self startIpcamStream]>0)
    {
        
        dispatch_queue_t rqueue=dispatch_queue_create("reThreadQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(rqueue, ^{
            [self receiveVideo];
        });
        dispatch_async(dispatch_queue_create("audioThreadQueue", DISPATCH_QUEUE_SERIAL), ^{
            [self receiveAudio];
        });
        
        
        
    }
    
    return 1;
}
-(void *) receiveAudio{
    NSLog(@"[thread_ReceiveAudio] Starting...");
    int ret;
    
    
    char *buf = malloc(AUDIO_BUF_SIZE);
    unsigned int frmNo;
    
    FRAMEINFO_t frameInfo;
    
    while (stopFlg)
    {
        ret = avCheckAudioBuf(avIndex);
        if (ret < 0) break;
        if (ret < 3) // determined by audio frame rate
        {
            usleep(120000);
            continue;
        }
        
        ret = avRecvAudioData(avIndex, buf, AUDIO_BUF_SIZE, (char *)&frameInfo, sizeof(FRAMEINFO_t), &frmNo);
        
        if(ret == AV_ER_SESSION_CLOSE_BY_REMOTE)
        {
            NSLog(@"[thread_ReceiveAudio] AV_ER_SESSION_CLOSE_BY_REMOTE");
            break;
        }
        else if(ret == AV_ER_REMOTE_TIMEOUT_DISCONNECT)
        {
            NSLog(@"[thread_ReceiveAudio] AV_ER_REMOTE_TIMEOUT_DISCONNECT");
            break;
        }
        else if(ret == IOTC_ER_INVALID_SID)
        {
            NSLog(@"[thread_ReceiveAudio] Session cant be used anymore");
            break;
        }
        else if (ret == AV_ER_LOSED_THIS_FRAME)
        {
            continue;
        }
        unsigned int nCodecId = 0;
        unsigned int nDatabits = 0;
        nCodecId = frameInfo.codec_id;
        unsigned int nSamplingRate = 44100;
        nSamplingRate = [self _getSampleRate:(frameInfo.flags)];
        
        int format = 0;
        nDatabits = (int)(frameInfo.flags >> 1 & 1);
        if (nDatabits == AUDIO_DATABITS_8 && avIndex == AUDIO_CHANNEL_MONO)
            format = AL_FORMAT_MONO8;
        else if (nDatabits == AUDIO_DATABITS_8 && avIndex == AUDIO_CHANNEL_STERO)
            format = AL_FORMAT_STEREO8;
        else if (nDatabits == AUDIO_DATABITS_16 && avIndex == AUDIO_CHANNEL_MONO)
            format = AL_FORMAT_MONO16;
        else if (nDatabits == AUDIO_DATABITS_16 && avIndex == AUDIO_CHANNEL_STERO)
            format = AL_FORMAT_STEREO16;
        else
            format = AL_FORMAT_MONO16;
        
        //NSLog(@"=====%d",format);
        if(delegate !=NULL){
            if (nCodecId == MEDIA_CODEC_AUDIO_G711A) {
                int Retade = 0;
                char *data=malloc(2048);
                Retade = G711a2PCM( buf, data, ret, 0 );
                
                if ([delegate respondsToSelector:@selector(onReceivedAudio::::)]) {
                    [delegate onReceivedAudio:data:Retade : nSamplingRate : format];
                }
                free(data);
            }
            
            
        }
        
    }
    free(buf);
    NSLog(@"[thread_ReceiveAudio] thread exit");
    return 0;
}

-(void *) receiveVideo
{
    NSLog(@"[thread_ReceiveVideo] Starting...");
    int ret,error_count=0;
    int outBufSize = 0, outFrmSize = 0, outFrmInfoSize = 0;
    char *buf = malloc(VIDEO_BUF_SIZE);
    unsigned int frmNo;
    
    FRAMEINFO_t frameInfo;
    srand((unsigned)time(NULL));
    
    while (stopFlg)
    {
        
        //ret = avRecvFrameData(avIndex, buf, VIDEO_BUF_SIZE, (char *)&frameInfo, sizeof(FRAMEINFO_t), &frmNo);
        memset(buf, 0, VIDEO_BUF_SIZE);
        ret= avRecvFrameData2(avIndex, buf, VIDEO_BUF_SIZE, &outBufSize,
                              &outFrmSize,  (char *)&frameInfo, sizeof(FRAMEINFO_t),
                              &outFrmInfoSize, &frmNo);
        /**/
        
        if(ret == AV_ER_DATA_NOREADY)
        {
            usleep(30000);
            continue;
        }
        else if(ret == AV_ER_LOSED_THIS_FRAME)
        {
            
            NSLog(@"Lost video frame NO[%d]", frmNo);
            continue;
        }
        else if(ret == AV_ER_INCOMPLETE_FRAME)
        {
            error_count=1;
            
            NSLog(@"Incomplete video frame NO[%d]", frmNo);
            continue;
        }
        else if(ret == AV_ER_SESSION_CLOSE_BY_REMOTE)
        {
            NSLog(@"[thread_ReceiveVideo] AV_ER_SESSION_CLOSE_BY_REMOTE");
            break;
        }
        else if(ret == AV_ER_REMOTE_TIMEOUT_DISCONNECT)
        {
            NSLog(@"[thread_ReceiveVideo] AV_ER_REMOTE_TIMEOUT_DISCONNECT");
            break;
        }
        else if(ret == IOTC_ER_INVALID_SID)
        {
            NSLog(@"[thread_ReceiveVideo] Session cant be used anymore");
            break;
        }
        
        
        if(frameInfo.flags == IPC_FRAME_FLAG_IFRAME)
        {
            error_count=0;
            // got an IFrame, draw it.
            if(delegate !=NULL){
                uint8_t *data=malloc(ret);
                memcpy(data, buf, ret);
                
                if ([delegate respondsToSelector:@selector(onReceivedBPFrame::)]) {
                    [delegate onReceivedBPFrame:data : ret];
                }
                free(data);
                
            }
            NSLog(@"%s,%d","got an IFrame, draw it",ret);
            
        }
        
        
        if(frameInfo.flags == IPC_FRAME_FLAG_PBFRAME){
            if(ret>0 && error_count==0){
                if(delegate !=NULL){
                    uint8_t *data=malloc(ret);
                    
                    memcpy(data, buf, ret);
                    if([delegate respondsToSelector:@selector(onReceivedBPFrame::)])
                    {
                        [delegate onReceivedBPFrame:data : ret];
                    }
                    //NSData *ndata = [NSData dataWithBytes: data length:ret];
                    //NSLog(@"2%@",ndata);
                    free(data);
                    
                }
            }
            //NSLog(@"got an BPFrame, draw it.");
            
        }
        
        
    }
    free(buf);
    [self closeSession];
    
    NSLog(@"[thread_ReceiveVideo] thread exit");
    return 0;
}

-(void) closeSession{
    stopFlg=0;
    avClientStop(avIndex);
    NSLog(@"avClientStop OK");
    IOTC_Session_Close(SID);
    NSLog(@"IOTC_Session_Close OK");
}

-(int) startIpcamStream {
    int ret;
    unsigned short val = 0;
    
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_INNER_SND_DATA_DELAY, (char *)&val, sizeof(unsigned short)) < 0))
    {
        NSLog(@"start_ipcam_stream_failed[%d]", ret);
        return 0;
    }
    
    SMsgAVIoctrlAVStream ioMsg;
    memset(&ioMsg, 0, sizeof(SMsgAVIoctrlAVStream));
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_START, (char *)&ioMsg, sizeof(SMsgAVIoctrlAVStream)) < 0))
    {
        NSLog(@"start_ipcam_stream_failed[%d]", ret);
        return 0;
    }
    
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_AUDIOSTART, (char *)&ioMsg, sizeof(SMsgAVIoctrlAVStream)) < 0))
    {
        NSLog(@"start_ipcam_stream_failed[%d]", ret);
        return 0;
    }
    
    return 1;
}

+(long) getTickCount {
    
    struct timeval tv;
    
    if (gettimeofday(&tv, NULL) != 0)
        return 0;
    
    return (tv.tv_sec * 1000 + tv.tv_usec / 1000);
}

-(void)stopAndCloseSession{
    stopFlg=0;
    
}


-(void) turn:(ENUM_TURN_CMD)direction{
    int ret;
    SMsgAVIoctrlPtzCmd *request = (SMsgAVIoctrlPtzCmd *)malloc(sizeof(SMsgAVIoctrlPtzCmd));
    request->channel = avIndex;
    request->speed = PT_SPEED;
    request->point = 0;
    request->limit = 0;
    request->aux = 0;
    if(direction==IOCTRL_U){
        request->control = AVIOCTRL_PTZ_UP;
    }
    if(direction==IOCTRL_D){
        request->control = AVIOCTRL_PTZ_DOWN;
    }
    if(direction == IOCTRL_L){
        request->control = AVIOCTRL_PTZ_LEFT;
    }
    if(direction == IOCTRL_R){
        request->control = AVIOCTRL_PTZ_RIGHT;
    }
    
    if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_PTZ_COMMAND, (char *)request, sizeof(request)) < 0))
    {
        NSLog(@"send IOTYPE_USER_IPCAM_PTZ_COMMAND fail [%d]", ret);
        
    }
    
    free(request);
}

//加锁解锁
- (void)lock_unlock:(int)lockIndex status:(BOOL)status{
    int ret;
    SMsgLockContral *request = (SMsgLockContral *)malloc(sizeof(SMsgLockContral));
    request->nControl = status;
    request->nNeedKey = 0;
    if (lockIndex == 1) {
        if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_APP_LOCK1, (char *)request, sizeof(request)) < 0)) {
            NSLog(@"发送A锁定指令失败[%d]",ret);
        }
    } else {
        if ((ret = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_APP_LOCK2, (char *)request, sizeof(request)) < 0)) {
            NSLog(@"发送B锁定指令失败[%d]",ret);
        }
    }
    free(request);
}

- (int)_getSampleRate:(unsigned char)flag {
    
    switch(flag >> 2) {
            
        case AUDIO_SAMPLE_8K:
            return 8000;
            break;
            
        case AUDIO_SAMPLE_11K:
            return 11025;
            break;
            
        case AUDIO_SAMPLE_12K:
            return 12000;
            break;
            
        case AUDIO_SAMPLE_16K:
            return 16000;
            break;
            
        case AUDIO_SAMPLE_22K:
            return 22050;
            break;
            
        case AUDIO_SAMPLE_24K:
            return 24000;
            break;
            
        case AUDIO_SAMPLE_32K:
            return 32000;
            break;
            
        case AUDIO_SAMPLE_44K:
            return 44100;
            break;
            
        case AUDIO_SAMPLE_48K:
            return 48000;
            break;
            
        default:
            return 8000;
    }
}

@end