//
//  MainTableViewCell.h
//  P2PCamera
//
//  Created by Raindy on 16/3/1.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraObject.h"

typedef void(^LeftImageViewTap)(NSInteger m);
typedef void(^RightImageViewTap)(NSInteger n);

@interface MainTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *firstLabel;
@property (strong, nonatomic) UILabel *secondLabel;
@property (strong, nonatomic) UILabel *thirdLabel;
@property (strong, nonatomic) UIImageView *rightImageView;

@property (nonatomic,copy)LeftImageViewTap lComplection;
@property (nonatomic,copy)RightImageViewTap rComplection;

- (void)setCell:(CameraObject *)object;
- (void)setOnlineStatus:(BOOL)on;

@end
