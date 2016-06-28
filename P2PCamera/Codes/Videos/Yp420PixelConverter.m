
#include <objc/NSObject.h>
#import <Foundation/Foundation.h>
#import "Yp420PixelConverter.h"
#include <AVFoundation/AVFoundation.h>
#import "Endian.h"
#import <UIKit/UIKit.h>

#define clamp(a) (a>255?255:(a<0?0:a));

@implementation Yp420PixelConverter

-(NSData *) toNSData:(CVPixelBufferRef) pixelBuffer{
    
    CVPixelBufferLockBaseAddress(pixelBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(pixelBuffer);
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
    
    CVPlanarPixelBufferInfo_YCbCrBiPlanar *bufferInfo = (CVPlanarPixelBufferInfo_YCbCrBiPlanar *)baseAddress;
    uint8_t* cbrBuff = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    // convert the image
    UIImage *image = [self makeUIImage:baseAddress cBCrBuffer:cbrBuff bufferInfo:bufferInfo width:width height:height bytesPerRow:bytesPerRow];
    NSData *data = UIImagePNGRepresentation(image);
    return data;
}

- (UIImage *)makeUIImage:(uint8_t *)inBaseAddress cBCrBuffer:(uint8_t*)cbCrBuffer bufferInfo:(CVPlanarPixelBufferInfo_YCbCrBiPlanar *)inBufferInfo width:(size_t)inWidth height:(size_t)inHeight bytesPerRow:(size_t)inBytesPerRow {
    
    NSUInteger yPitch = EndianU32_BtoN(inBufferInfo->componentInfoY.rowBytes);
    //NSUInteger cbCrOffset = EndianU32_BtoN(inBufferInfo->componentInfoCbCr.offset);
    uint8_t *rgbBuffer = (uint8_t *)malloc(inWidth * inHeight * 4);
    NSUInteger cbCrPitch = EndianU32_BtoN(inBufferInfo->componentInfoCbCr.rowBytes);
    uint8_t *yBuffer = (uint8_t *)inBaseAddress;
    //uint8_t *cbCrBuffer = inBaseAddress + cbCrOffset;
    //uint8_t val;
    int bytesPerPixel = 4;
    
    for(int y = 0; y < inHeight; y++)
    {
        uint8_t *rgbBufferLine = &rgbBuffer[y * inWidth * bytesPerPixel];
        uint8_t *yBufferLine = &yBuffer[y * yPitch];
        uint8_t *cbCrBufferLine = &cbCrBuffer[(y >> 1) * cbCrPitch];
        
        for(int x = 0; x < inWidth; x++)
        {
            int16_t y = yBufferLine[x];
            int16_t cb = cbCrBufferLine[x & ~1] - 128;
            int16_t cr = cbCrBufferLine[x | 1] - 128;
            
            uint8_t *rgbOutput = &rgbBufferLine[x*bytesPerPixel];
            
            int16_t r = (int16_t)roundf( y + cr *  1.4 );
            int16_t g = (int16_t)roundf( y + cb * -0.343 + cr * -0.711 );
            int16_t b = (int16_t)roundf( y + cb *  1.765);
            
            //ABGR
            rgbOutput[0] = 0xff;
            rgbOutput[1] = clamp(b);
            rgbOutput[2] = clamp(g);
            rgbOutput[3] = clamp(r);
        }
    }
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSLog(@"ypitch:%lu inHeight:%zu bytesPerPixel:%d",(unsigned long)yPitch,inHeight,bytesPerPixel);
    NSLog(@"cbcrPitch:%lu",cbCrPitch);
    CGContextRef context = CGBitmapContextCreate(rgbBuffer, inWidth, inHeight, 8,
                                                 inWidth*bytesPerPixel, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    CGImageRelease(quartzImage);
    free(rgbBuffer);
    return  image;
}

@end