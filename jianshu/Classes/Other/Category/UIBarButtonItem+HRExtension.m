//
//  UIBarButtonItem+HRExtension.m
//  jianshu
//
//  Created by Hiro on 16/5/18.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "UIBarButtonItem+HRExtension.h"

@implementation UIBarButtonItem (HRExtension)
+(instancetype)itemWithImage:(NSString *)image highImag:(NSString *)highImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
   
}
@end
