#import <Foundation/Foundation.h>
#include "VideoFileParser.h"

const uint8_t KStartCode[4] = {0, 0, 0, 1};


@implementation VideoFileParser

@synthesize _buffer;
@synthesize _bufferSize;

@synthesize point_index;
@synthesize point_begin;

-(NSInteger)nextPacket:(char*) _ibuf
{
    if(memcmp(_buffer, KStartCode, 4) != 0) {
        return 0;
    }
    
    if(_bufferSize < 5) {
        return 0;
    }
    
    if(point_index==0){
        point_index=point_index+4;
        
    }
    
    
    
    while(point_index < _bufferSize) {
        //NSLog(@"=======%2X,%ld",_buffer[point_index],(long)point_index);
        if(_buffer[point_index] == 0x01) {
            if(_buffer[point_index-1]==0 && _buffer[point_index-2]==0 && _buffer[point_index-3]==0) {
                NSInteger packetSize = point_index-point_begin - 3;
                
                memcpy(_ibuf, _buffer+point_begin, packetSize);
                
                ++point_index;
                point_begin=point_index-4;
                return packetSize;
            }
        }
        ++point_index;
    }
    NSInteger packetSize=_bufferSize-point_begin;
    memcpy(_ibuf, _buffer+point_begin, packetSize);
    point_begin=_bufferSize;
    return packetSize;
    
}

@end