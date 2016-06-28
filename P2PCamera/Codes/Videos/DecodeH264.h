#include <objc/NSObject.h>

@protocol DecodeH264Delegate<NSObject>
-(void)onDecodeComplete:(CVPixelBufferRef) pixelBuffer;
@end

@interface DecodeH264 : NSObject

-(void)decode:(uint8_t *)_buffer : (NSInteger) _bufferSize;
-(void)clearH264Deocder;

@property (nonatomic,retain) id delegate;
@end