//
//  HRTabBarController.m
//  jianshu
//
//  Created by Hiro on 16/5/17.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRTabBarController.h"
#import "HRDiscoverController.h"
//#import "HRSubscriptionController.h"
#import "HRReadController.h"
#import "HRNotificationController.h"
#import "HRMyController.h"
#import "HRTabBar.h"
#import "HRNavigationController.h"
//#import "HRReaderViewController.h"
@implementation HRTabBarController
/**
 * 当第一次使用这个类的时候会调用一次
 */
+(void)initialize {
    [UINavigationBar appearance];
    //通过appearance 统一设置所有uitabBarItem的文字属性
    NSMutableDictionary *dics = [NSMutableDictionary dictionary];
    dics[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dics[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedDics = [NSMutableDictionary dictionary];
    selectedDics[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedDics[NSForegroundColorAttributeName] = [UIColor redColor];
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:dics forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedDics forState:UIControlStateSelected];
}
-(void)viewDidLoad {
    [super viewDidLoad];
    [self addTabBar];
   }

-(void)addTabBar {
    [self setupChildVC:[[HRDiscoverController alloc]init] title:@"发现"image:@"tabbar_icon_news_normal" selectedImage:@"tabbar_icon_news_highlight"];
     [self setupChildVC:[[HRNotificationController alloc]init] title:@"视频"image:@"tabbar_icon_media_normal" selectedImage:@"tabbar_icon_media_highlight"];

    [self setupChildVC:[[HRReadController alloc]init] title:@"阅读" image:@"tabbar_icon_reader_normal" selectedImage:@"tabbar_icon_reader_highlight"];
//     [self setupChildVC:[[HRReaderViewController alloc]init] title:@"阅读" image:@"tabbar_icon_reader_normal" selectedImage:@"tabbar_icon_reader_highlight"];
    [self setupChildVC:[[HRMyController alloc]init] title:@"我的" image:@"tabbar_icon_me_normal" selectedImage:@"tabbar_icon_me_highlight"];

    //更换tabbar
    [self setValue:[[HRTabBar alloc]init] forKey:@"tabBar"];

}
//初始化子控制器
- (void)setupChildVC:(UIViewController *)vc title:(NSString*)title image:(NSString*)image selectedImage:(NSString*)selectedImage {
    vc.navigationItem.title =title;
    vc.tabBarItem.title = title;
    UIImage *Image =[UIImage imageNamed:image];
    vc.tabBarItem.image =[Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage =[UIImage imageNamed:selectedImage];
    vc.tabBarItem.selectedImage =[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     //包装一个导航控制器，添加导航控制器为tabBarcontroller的子控制器
    HRNavigationController *nav =[[HRNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}
@end
