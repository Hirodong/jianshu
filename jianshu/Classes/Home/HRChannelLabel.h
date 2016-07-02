//
//  HRChannelLabel.h
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRChannelLabel : UILabel
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat textWidth;

+ (instancetype)channelLabelWithTitle:(NSString *)title;
@end
