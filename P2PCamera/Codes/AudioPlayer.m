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

- (void)SearchAndConnect:(SearchBlock)searchBlock {
    struct st_LanSearchInfo  p[100];
    
    IOTC_Lan_Search(p, 100, 100);
    
    for(int i = 0;i < 100;i++) {
        NSString *str = [NSString stringWithFormat:@"%s",p[i].UID];
        if (str != NULL && ![str isEqualToString:@""]) {
            NSLog(@"%@",str);
            searchBlock(str);
        }
    }
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
