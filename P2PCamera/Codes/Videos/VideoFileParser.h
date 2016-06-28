#include <objc/NSObject.h>



@interface VideoFileParser : NSObject


@property uint8_t *_buffer;
@property NSInteger _bufferSize;
@property long point_index;
@property long point_begin;

-(NSInteger)nextPacket : (char*) buf;

@end
