

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//-(void)decodeFile:(uint8_t *)_buffer : (int) ret;
//-(void)decode:(uint8_t *)_buffer : (NSInteger) _bufferSize;
//-(void) save:(uint8_t *)_ibuff : (int) length;

-(void)onReceivedAudio:(char*) data : (int) length : (unsigned int) rate : (unsigned int)format;

@end

