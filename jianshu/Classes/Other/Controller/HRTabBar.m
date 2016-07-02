//
//  HRTabBar.m
//  jianshu
//
//  Created by Hiro on 16/5/17.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRTabBar.h"
@interface HRTabBar ()
/**写贴按钮*/
@property (nonatomic,weak) UIButton *writeButton;
@end
@implementation HRTabBar

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [writeButton setBackgroundImage:[UIImage imageNamed:@"button_write"] forState:UIControlStateNormal];
        writeButton.size = writeButton.currentBackgroundImage.size;
        [self addSubview:writeButton];
        self.writeButton = writeButton;
    }
    return self;
    
}
-(void)layoutSubviews {
    [super layoutSubviews ];
    CGFloat width = self.width;
    CGFloat height = self.height;
    //设置按钮的frame
    self.writeButton.center = CGPointMake(width*0.5, height*0.5);
    //设置其他uitabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW =width/5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIView *button  in self.subviews) {
        if (![button isKindOfClass:[UIControl class]]||button == self.writeButton) continue;
        CGFloat buttonX = buttonW *((index>1)?(index +1):index);
        button.frame =CGRectMake(buttonX, buttonY, buttonW, buttonH);
        index++;
    }
}
@end
