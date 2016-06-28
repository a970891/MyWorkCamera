//
//  QRMenu.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/30.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRMenu.h"
#import "BasicDefinetion.h"

@implementation QRMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
     
        [self setupQRItem];
        
    }
    
    return self;
}

- (void)setupQRItem {
    
    UILabel *upLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*AUTO_WIDTH, 5*AUTO_HEIGHT, self.frame.size.width-10*AUTO_WIDTH, 20*AUTO_HEIGHT)];
    upLabel.text = @"扫描设备上的二维码";
    upLabel.font = [UIFont systemFontOfSize:18];
    upLabel.textAlignment = NSTextAlignmentCenter;
    upLabel.textColor = [UIColor whiteColor];
//    [self addSubview:upLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5*AUTO_WIDTH, 30*AUTO_HEIGHT, self.frame.size.width-10*AUTO_WIDTH, 1*AUTO_HEIGHT)];
    lineView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:lineView];
    
    _writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _writeBtn.frame = CGRectMake(5*AUTO_WIDTH, 36*AUTO_HEIGHT, self.frame.size.width-30*AUTO_WIDTH, 20*AUTO_HEIGHT);
    [_writeBtn setTitle:@"或者输入产品的序列号" forState:UIControlStateNormal];
    _writeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_writeBtn addTarget:self action:@selector(tapToSelected:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_writeBtn];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-27*AUTO_WIDTH, 36*AUTO_HEIGHT, 20*AUTO_WIDTH, 20*AUTO_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"bdsb_01_01"];
//    [self addSubview:imageView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(10*AUTO_WIDTH, 10*AUTO_HEIGHT, self.frame.size.width-20*AUTO_WIDTH, 20*AUTO_HEIGHT);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBack:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
//    QRItem *qrItem = [[QRItem alloc] initWithFrame:(CGRect){
//        .origin.x = 0,
//        .origin.y = 0,
//        .size.width = self.bounds.size.width / 2,
//        .size.height = self.bounds.size.height
//    } titile:@"二维码扫描"];
//    qrItem.type = QRItemTypeQRCode;
//    [self addSubview:qrItem];
//    
//    QRItem *otherItem = [[QRItem alloc] initWithFrame: (CGRect){
//        
//        .origin.x = self.bounds.size.width / 2,
//        .origin.y = 0,
//        .size.width = self.bounds.size.width / 2,
//        .size.height = self.bounds.size.height
//    } titile:@"条形码扫描"];
//    otherItem.type = QRItemTypeOther;
//    [self addSubview:otherItem];
//    
//    [qrItem addTarget:self action:@selector(qrScan:) forControlEvents:UIControlEventTouchUpInside];
//    [otherItem addTarget:self action:@selector(qrScan:) forControlEvents:UIControlEventTouchUpInside];

}


#pragma mark - Action

- (void)qrScan:(QRItem *)qrItem {
    
    if (self.didSelectedBlock) {
        
        self.didSelectedBlock(qrItem);
    }
}

- (void)tapToSelected:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"input" object:nil];
}

- (void)cancelBack:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"input" object:nil];
}



@end
