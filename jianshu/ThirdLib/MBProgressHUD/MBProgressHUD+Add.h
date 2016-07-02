//
//  ViewController.h
//  MBProgressHUB+Add
//
//  Created by shen_gh on 16/5/5.
//  Copyright © 2016年 shenAlexy. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showMessageWithRefresh:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)timeInterval;
;
+ (void)showMessage:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)timeInterval;
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
- (void)showError:(NSString *)error;
- (void)showSuccess:(NSString *)success;

@end
