//
//  HRNavigationController.m
//  jianshu
//
//  Created by Hiro on 16/5/18.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRNavigationController.h"

@implementation HRNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
+(void)initialize {
    UINavigationBar *bar= [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}
//拦截所有push进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count>0) {
        //如果push进来的不是第一个控制器
        viewController.hidesBottomBarWhenPushed =YES;//隐藏tabbar
    }
    viewController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [super pushViewController:viewController animated:animated];
    
}
@end
