//
//  MainTableViewCell.m
//  P2PCamera
//
//  Created by Raindy on 16/3/1.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "MainTableViewCell.h"
#import "BasicDefinetion.h"
@implementation MainTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Setter & Getter
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.leftImageView];
        [self addSubview:self.firstLabel];
        [self addSubview:self.secondLabel];
        [self addSubview:self.thirdLabel];
        [self addSubview:self.rightImageView];
    }
    return self;
}

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 60*AUTO_HEIGHT, 60*AUTO_HEIGHT)];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLeft:)];
        [_leftImageView addGestureRecognizer:leftTap];
        _leftImageView.image = [UIImage imageNamed:@"camera_logo"];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(280*AUTO_WIDTH, 15*AUTO_HEIGHT, 30*AUTO_WIDTH, 30*AUTO_HEIGHT)];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.userInteractionEnabled = YES;
        _rightImageView.image = [UIImage imageNamed:@"jinggao1"];
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRight:)];
        [_rightImageView addGestureRecognizer:rightTap];
    }
    return _rightImageView;
}

- (UILabel *)firstLabel{
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(90*AUTO_WIDTH, 10*AUTO_HEIGHT, 120*AUTO_WIDTH, 20*AUTO_HEIGHT)];
        _firstLabel.font = [UIFont systemFontOfSize:17];
    }
    return _firstLabel;
}

- (UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(90*AUTO_WIDTH, 30*AUTO_HEIGHT, 200*AUTO_WIDTH, 20*AUTO_HEIGHT)];
        _secondLabel.font = [UIFont systemFontOfSize:12];
        _secondLabel.alpha = 0.7;
    }
    return _secondLabel;
}

- (void)setCodeText:(NSString *)text image:(NSString *)image{
    self.thirdLabel.text = text;
//    self.leftImageView.sd_
}

- (UILabel *)thirdLabel{
    if (!_thirdLabel) {
        _thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(90*AUTO_WIDTH, 50*AUTO_HEIGHT, 180*AUTO_WIDTH, 20*AUTO_HEIGHT)];
        _thirdLabel.font = [UIFont systemFontOfSize:15];
        _thirdLabel.alpha = 0.5;
    }
    return _thirdLabel;
}
#pragma mark - Helper Methods

- (void)tapLeft:(UITapGestureRecognizer *)tap{
    self.lComplection(1);
}

- (void)tapRight:(UITapGestureRecognizer *)tap
{
    self.rComplection(1);
}

- (void)setCell:(CameraObject *)object{
    self.firstLabel.text = object.name;
    self.secondLabel.text = [NSString stringWithFormat:@"UID:%@",object.uid];
}

- (void)setOnlineStatus:(BOOL)on name:(NSString *)name {
    _firstLabel.text = on ? [NSString stringWithFormat:@"%@(在线)",name] : [NSString stringWithFormat:@"%@(离线)",name];
}

@end
