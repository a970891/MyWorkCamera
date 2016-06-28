#include <objc/NSObject.h>
#include <AVFoundation/AVFoundation.h>

@interface Yp420PixelConverter : NSObject

-(NSData *) toNSData:(CVPixelBufferRef) pixelBuffer;
@end