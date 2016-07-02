//
//  HRChannelLabel.m
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRChannelLabel.h"

@implementation HRChannelLabel

+ (instancetype)channelLabelWithTitle:(NSString *)title
{
    HRChannelLabel *label = [self new];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [label sizeToFit];
    label.userInteractionEnabled = YES;
    return label;
}

- (CGFloat)textWidth
{
    return [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].width + 8; 
}


- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.textColor = [UIColor colorWithRed:scale*0.176 green:scale*0.722 blue:scale*0.945 alpha:1];
}



- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, self.text];
}


@end
