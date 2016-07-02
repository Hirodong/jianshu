//
//  HRSortCell.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRSortCell.h"

@implementation HRSortCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_button setBackgroundImage:[UIImage imageNamed:@"channel_sort_circle"] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_button];
    }
    return self;
}



@end
