//
//  AudioPlayer.m
//  P2PCamera
//
//  Created by meizu on 16/4/16.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "AudioPlayer.h"
#import "KxMovieViewController.h"
#import "KxAudioManager.h"
#include <AudioToolbox/AudioQueue.h>
#include <AVFoundation/AVAudioSession.h>
#import "OpenALPlayer.h"
#import "ViewController.h"

#import "IOTCAPIs.h"
#import <sys/time.h>
#import "AVAPIs.h"
#include "pthread.h"
#import "AVIOCTRLDEFs.h"
#import "AVFRAMEINFO.h"
#import "SVProgressHUD.h"

#import "MCSimpleAudioPlayer.h"
#import "MCAudioBuffer.h"
#import "MCParsedAudioData.h"
#include <CoreAudio/CoreAudioTypes.h>

#define AUDIO_BUF_SIZE	1024
#define VIDEO_BUF_SIZE	2000000

@interface AudioPlayer () {
    MCSimpleAudioPlayer *_player;
}

@end

@implementation AudioPlayer

unsigned int _getTickCount() {
    
    struct timeval tv;
    
    if (gettimeofday(&tv, NULL) != 0)
        return 0;
    
    return (unsigned int)(tv.tv_sec * 1000 + tv.tv_usec / 1000);
}

- (void)IOTC_Init {
    int ret;
    NSLog(@"AVStream Client Start");
    
    unsigned short nUdpPort = (unsigned short)(10000 + (_getTickCount() % 10000));
    ret = IOTC_Initialize(nUdpPort, "50.19.254.134", "122.248.234.207", "m4.iotcplatform.com", "m5.iotcplatform.com");
    NSLog(@"IOTC_Initialize() ret = %d", ret);
    
    if (ret != IOTC_ER_NoERROR) {
        NSLog(@"IOTCAPIs exit...");
        return;
    }
    
    avInitialize(4);
}

- (NSString *)SearchAndConnect {
    NSLog(@"1");
    struct st_LanSearchInfo  p[1];
    int errorCode = IOTC_Lan_Search(p, 1, 100);
    NSLog(@"errorcode = %d", errorCode);
    
    NSLog(@"ip = %s,UID = %s",p[0].IP, p[0].UID);
    if ([[NSString  stringWithFormat:@"%s",p[0].IP] isEqualToString:@""]) {
        NSLog(@"找到0个摄像机");
        [SVProgressHUD showErrorWithStatus:@"找到0个摄像机"];
        return @"";
    } else {
        NSArray *arr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%s",p[0].IP], [NSString stringWithFormat:@"%s",p[0].UID],[NSNumber numberWithUnsignedShort:p[0].port], nil];
        NSLog(@"找到1个设备 :%@", arr[1]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"找到1个设备,已显示在摄像头列表" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return arr[1];
    }
    
//    return;
    
//    int SID = IOTC_Connect_ByUID(p[0].UID);
//    NSLog(@"connectCode = %d",SID);
//    struct st_SInfo Sinfo;
//    int ret = IOTC_Session_Check(SID, &Sinfo);
//    
//    if (ret >= 0)
//    {
//        if(Sinfo.Mode == 0)
//            printf("Device is from %s:%d[%s] Mode=P2P\n",Sinfo.RemoteIP, Sinfo.RemotePort, Sinfo.UID);
//        else if (Sinfo.Mode == 1)
//            printf("Device is from %s:%d[%s] Mode=RLY\n",Sinfo.RemoteIP, Sinfo.RemotePort, Sinfo.UID);
//        else if (Sinfo.Mode == 2)
//            printf("Device is from %s:%d[%s] Mode=LAN\n",Sinfo.RemoteIP, Sinfo.RemotePort, Sinfo.UID);
//    }
//    
//    unsigned long srvType;
//    int avIndex = avClientStart(SID, "admin", "admin123", 20000, &srvType, 0);
//    printf("Step 3: call avClientStart(%d).......\n", avIndex);
//    
//    if(avIndex < 0)
//    {
//        printf("avClientStart failed[%d]\n", avIndex);
//        return@"";
//    }
//    
//    if ([self start_ipcam_stream:avIndex])
//    {
//        pthread_t ThreadVideo_ID, ThreadAudio_ID;
//        pthread_create(&ThreadVideo_ID, NULL, &thread_ReceiveVideo, (void *)&avIndex);
//        pthread_create(&ThreadAudio_ID, NULL, &thread_ReceiveAudio, (void *)&avIndex);
//        pthread_join(ThreadVideo_ID, NULL);
//        pthread_join(ThreadAudio_ID, NULL);
//    }
//    
//    
//    avClientStop(avIndex);
//    NSLog(@"avClientStop OK");
//    IOTC_Session_Close(SID);
//    NSLog(@"IOTC_Session_Close OK");
//    avDeInitialize();
//    IOTC_DeInitialize();
//    
//    NSLog(@"StreamClient exit...");
    return @"";
}

void *thread_ReceiveAudio(void *arg)
{
    NSLog(@"[thread_ReceiveAudio] Starting...");
    
    int avIndex = *(int *)arg;
    char buf[AUDIO_BUF_SIZE];
    unsigned int frmNo;
    int ret;
    FRAMEINFO_t frameInfo;
    
    while (1)
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
        NSData *bufData = [NSData dataWithBytes:buf length:strlen(buf)];
        
        ViewController *vc = [[ViewController alloc]init];
    
        
        OpenALPlayer *player = [[OpenALPlayer alloc]init];
        
        NSLog(@"bufsize: %lu， iframeIndex: %u",(unsigned long)bufData.length, frmNo);
        
 
        /*
        AudioStreamPacketDescription packetDesc;
        packetDesc.mDataByteSize = ret;
        packetDesc.mVariableFramesInPacket = 0;
        packetDesc.mStartOffset = 0;
        MCParsedAudioData *data = [MCParsedAudioData parsedAudioDataWithBytes:buf packetDescription:packetDesc];
        MCAudioBuffer *_buffer = [MCAudioBuffer buffer];
        [_buffer enqueueData:data];
//         Now the data is ready in audioBuffer[0 ... ret - 1]
        // Do something here
        
        //        KxAudioManager *aManager = [KxAudioManager audioManager];
         */
        
    }
    
    NSLog(@"[thread_ReceiveAudio] thread exit");
    return 0;
}

void *thread_ReceiveVideo(void *arg)
{
    NSLog(@"[thread_ReceiveVideo] Starting...");
    
    int avIndex = *(int *)arg;
    char *buf = malloc(VIDEO_BUF_SIZE);
    unsigned int frmNo;
    int ret;
    FRAMEINFO_t frameInfo;
    
    while (1)
    {
        ret = avRecvFrameData(avIndex, buf, VIDEO_BUF_SIZE, (char *)&frameInfo, sizeof(FRAMEINFO_t), &frmNo);
        
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
            // got an IFrame, draw it.
        }
    }
    free(buf);
    NSLog(@"[thread_ReceiveVideo] thread exit");
    return 0;
}

- (int)start_ipcam_stream:(int)avIndex {
    
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

@end
