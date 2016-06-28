//
//  ZHLTTabBar.m
//  G1APP
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 ZHLT. All rights reserved.
//

#import "ZHLTTabBar.h"
#import "Masonry.h"

@implementation ZHLTTabBar

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage
{
    ZHLTTabBar  *btn = [[ZHLTTabBar alloc]initWithFrame:frame];
    btn.normalImage = normalImage;
    btn.title = title;
    btn.selectedImage = selectedImage;
    return btn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, self.bounds.size.width, 28)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 28, self.bounds.size.width, 21)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont  systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f];

        [self addSubview:_titleLabel];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(@3);
            make.height.equalTo(@28);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@21);
            
        }];
    }
    return self;
}
//UIControl的一个属性
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.imageView.image = _selectedImage;
        _titleLabel.textColor = [UIColor colorWithRed:225/255.0f green:105/255.0f blue:139/255.0f alpha:1.0f];
    }else{
        self.imageView.image = _normalImage;
        _titleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f];
        
    }
}

-(void)setNormalImage:(UIImage *)normalImage
{
    if (_normalImage != normalImage) {
        _normalImage = normalImage;
        
        if (!self.selected) {
            self.imageView.image = normalImage;
        }
    }
}

-(void)setSelectedImage:(UIImage *)selectedImage
{
    if (_selectedImage != selectedImage) {
        _selectedImage = selectedImage;
        if (self.selected) {
            self.imageView.image = selectedImage;
        }
    }
}

-(void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        
        self.titleLabel.text = title;
    }
    
}



@end
