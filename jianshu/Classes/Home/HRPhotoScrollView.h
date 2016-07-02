//
//  HRPhotoScrollView.h
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRPhotoScrollView : UIScrollView


@property (nonatomic, copy) void(^singleTapBlock)();

@property (nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString;
@end
