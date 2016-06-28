

#import <Foundation/Foundation.h>
#import "VideoFileParser.h"
#import <VideoToolbox/VideoToolbox.h>
#import "DecodeH264.h"

#define PACKAGE_BUF_SIZE	2000000
@implementation DecodeH264
{
    uint8_t *_sps;
    NSInteger _spsSize;
    uint8_t *_pps;
    NSInteger _ppsSize;
    VTDecompressionSessionRef _deocderSession;
    CMVideoFormatDescriptionRef _decoderFormatDescription;
    
    VideoFileParser *parser;
}

@synthesize delegate;

static void didDecompress( void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef pixelBuffer, CMTime presentationTimeStamp, CMTime presentationDuration ){
    
    CVPixelBufferRef *outputPixelBuffer = (CVPixelBufferRef *)sourceFrameRefCon;
    *outputPixelBuffer = CVPixelBufferRetain(pixelBuffer);
}

-(BOOL)initH264Decoder {
    if(_deocderSession) {
        return YES;
    }
    
    const uint8_t* const parameterSetPointers[2] = { _sps, _pps };
    const size_t parameterSetSizes[2] = { _spsSize, _ppsSize };
    OSStatus status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault,
                                                                          2, //param count
                                                                          parameterSetPointers,
                                                                          parameterSetSizes,
                                                                          4, //nal start code size
                                                                          &_decoderFormatDescription);
    
    if(status == noErr) {
        CFDictionaryRef attrs = NULL;
        const void *keys[] = { kCVPixelBufferPixelFormatTypeKey };
        //      kCVPixelFormatType_420YpCbCr8Planar is YUV420
        //      kCVPixelFormatType_420YpCbCr8BiPlanarFullRange is NV12
        uint32_t v = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
        const void *values[] = { CFNumberCreate(NULL, kCFNumberSInt32Type, &v) };
        attrs = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
        
        VTDecompressionOutputCallbackRecord callBackRecord;
        callBackRecord.decompressionOutputCallback = didDecompress;
        callBackRecord.decompressionOutputRefCon = NULL;
        
        VTDecompressionSessionCreate(kCFAllocatorDefault,
                                     _decoderFormatDescription,
                                     NULL, attrs,
                                     &callBackRecord,
                                     &_deocderSession);
        CFRelease(attrs);
    } else {
        NSLog(@"IOS8VT: reset decoder session failed status=%d", status);
    }
    
    return YES;
}

-(void)clearH264Deocder {
    if(_deocderSession) {
        VTDecompressionSessionInvalidate(_deocderSession);
        CFRelease(_deocderSession);
        _deocderSession = NULL;
    }
    
    if(_decoderFormatDescription) {
        CFRelease(_decoderFormatDescription);
        _decoderFormatDescription = NULL;
    }
    
    
    _spsSize = _ppsSize = 0;
    if(NULL != _sps){
        free(_sps);
        _sps=NULL;
    }
    if(NULL != _pps){
        free(_pps);
        _pps=NULL;
    }
}

-(CVPixelBufferRef)decodeCvPixel:(Byte*)_ibuffer : (NSInteger) size {
    CVPixelBufferRef outputPixelBuffer = NULL;
    
    CMBlockBufferRef blockBuffer = NULL;
    OSStatus status  = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault,
                                                          _ibuffer, size,
                                                          kCFAllocatorNull,
                                                          NULL, 0, size,
                                                          0, &blockBuffer);
    if(status == kCMBlockBufferNoErr) {
        CMSampleBufferRef sampleBuffer = NULL;
        const size_t sampleSizeArray[] = {size};
        status = CMSampleBufferCreateReady(kCFAllocatorDefault,
                                           blockBuffer,
                                           _decoderFormatDescription ,
                                           1, 0, NULL, 1, sampleSizeArray,
                                           &sampleBuffer);
        
        
        
        if (status == kCMBlockBufferNoErr && sampleBuffer) {
            VTDecodeFrameFlags flags = 0;
            VTDecodeInfoFlags flagOut = 0;
            OSStatus decodeStatus = VTDecompressionSessionDecodeFrame(_deocderSession,
                                                                      sampleBuffer,
                                                                      flags,
                                                                      &outputPixelBuffer,
                                                                      &flagOut);
            
            if(decodeStatus == kVTInvalidSessionErr) {
                NSLog(@"IOS8VT: Invalid session, reset decoder session");
            } else if(decodeStatus == kVTVideoDecoderBadDataErr) {
                //NSData *ndata = [NSData dataWithBytes: _ibuffer length:size];
                //NSLog(@"1%@",ndata);
                
                NSLog(@"IOS8VT: decode failed status=%d(Bad data)", decodeStatus);
            } else if(decodeStatus != noErr) {
                //NSData *ndata = [NSData dataWithBytes: _ibuffer length:size];
                //NSLog(@"3%@",ndata);
                NSLog(@"IOS8VT: decode failed status=%d", decodeStatus);
            }
            
            CFRelease(sampleBuffer);
            
        }
        CFRelease(blockBuffer);
    }
    
    return outputPixelBuffer;
}


-(void)decode:(uint8_t *)_buffer : (NSInteger) _bufferSize {
    
    if(parser == nil){
        parser = [[VideoFileParser alloc] init];
    }
    parser._buffer=_buffer;
    parser._bufferSize=_bufferSize;
    parser.point_index=0;
    parser.point_begin=0;
    
    
    NSInteger split_size=0;
    NSInteger bf=0;
    
    char *buf = malloc(PACKAGE_BUF_SIZE);
    while(true) {
        
        NSInteger ret = [parser nextPacket:buf];
        
        if(ret <1) {
            break;
        }
        
        if(buf[4]==0x6){
            continue;
        }
        
        
        NSData *ndata1 = [NSData dataWithBytes: buf length:30];
        NSLog(@"5%@",ndata1);

        
        NSInteger _size=ret;
        Byte *pByte = (Byte *)malloc(ret);
        memcpy(pByte, buf, ret);
                
        if(bf<2){
            split_size=split_size+_size;
        }
        uint32_t nalSize = (uint32_t)(_size - 4);
        uint8_t *pNalSize = (uint8_t*)(&nalSize);
        pByte[0] = *(pNalSize + 3);
        pByte[1] = *(pNalSize + 2);
        pByte[2] = *(pNalSize + 1);
        pByte[3] = *(pNalSize);
        
        CVPixelBufferRef pixelBuffer = NULL;
        int nalType = pByte[4] & 0x1F;
        //NSLog(@"")
        switch (nalType) {
            case 0x05:
                //NSLog(@"Nal type is IDR frame");
                
                if([self initH264Decoder]) {
                    pixelBuffer = [self decodeCvPixel:pByte :_size];
                    
                }
                if(NULL != _sps){
                    free(_sps);
                    _sps=NULL;
                }
                if(NULL != _pps){
                    free(_pps);
                    _pps=NULL;
                }
                
                break;
            case 0x07:
                //NSLog(@"Nal type is SPS");
                _spsSize = _size - 4;
                _sps = malloc(_spsSize);
                memcpy(_sps, pByte + 4, _spsSize);
                break;
            case 0x08:
                //NSLog(@"Nal type is PPS");
                _ppsSize = _size - 4;
                _pps = malloc(_ppsSize);
                memcpy(_pps, pByte + 4, _ppsSize);
                
                break;
                
            default:
                bf=bf+1;
                
                pixelBuffer = [self decodeCvPixel:pByte :_size];
                break;
        }
        
        if(pixelBuffer) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(delegate !=nil){
                    [delegate onDecodeComplete:pixelBuffer];
                }
                //_glLayer.pixelBuffer = pixelBuffer;
            });
            CVPixelBufferRelease(pixelBuffer);
            
        }
        
        free(pByte);
        
    }
    free(buf);
}

@end