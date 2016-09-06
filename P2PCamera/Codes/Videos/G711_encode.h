//
//  G711_encode.h
//  P2PCamera
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 Lu. All rights reserved.
//

#ifndef __G_711_H_
#define __G_711_H_

#include <stdint.h>
#include <stdio.h>

enum _e_g711_tp

{
    
    TP_ALAW, //G711A
    
    TP_ULAW //G711U
    
}G711Type;



unsigned char _linear2alaw(int pcm_val); /* 2's complement (16-bit range) */

int _alaw2linear(unsigned char a_val);



unsigned char _linear2ulaw(int pcm_val); /* 2's complement (16-bit range) */

int _ulaw2linear(unsigned char u_val);



unsigned char _alaw2ulaw(unsigned char aval);

unsigned char _ulaw2alaw(unsigned char uval);



int _g711_decode(void *pout_buf, int *pout_len, const void *pin_buf, const int in_len , int type);



#endif