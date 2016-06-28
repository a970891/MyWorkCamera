//
//  BCell.m
//  P2PCamera
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "BBCell.h"
#import "BasicDefinetion.h"
#import "CameraObject.h"

@implementation BBCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*AUTO_WIDTH, 5*AUTO_HEIGHT, 80*AUTO_WIDTH, 34*AUTO_HEIGHT)];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    _descLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*AUTO_WIDTH, 5*AUTO_HEIGHT, lScreenWidth - 80*AUTO_WIDTH, 34*AUTO_HEIGHT)];
    _descLabel.font = [UIFont systemFontOfSize:10];
    _descLabel.textColor = [UIColor lightGrayColor];
    _descLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_titleLabel];
    [self addSubview:_descLabel];
}

- (void)setCell:(NSInteger)index camera:(CameraObject *)object {
    _titleLabel.text = [NSString stringWithFormat:@"摄像机%ld",index];
    _descLabel.text = [NSString stringWithFormat:@"uid:%@|密码:%@",object.uid,object.password];
}

@end
