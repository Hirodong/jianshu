//
//  UIBarButtonItem+HRExtension.h
//  jianshu
//
//  Created by Hiro on 16/5/18.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HRExtension)
+(instancetype)itemWithImage:(NSString*)image highImag:(NSString*)highImage target:(id)target action:(SEL)action;
@end
