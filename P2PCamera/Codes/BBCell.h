//
//  BCell.h
//  P2PCamera
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraObject.h"

@interface BBCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *descLabel;

- (void)setCell:(NSInteger)index camera:(CameraObject *)object;

@end
