//
//  HRDetailViewController.h
//  jianshu
//
//  Created by Hiro on 16/5/19.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRHTPlayer.h"
#import "VideoModel.h"
@interface HRDetailViewController : UIViewController

@property (strong, nonatomic)HRHTPlayer *htPlayer;
@property (strong, nonatomic)VideoModel *model;
@property (strong, nonatomic)UIView *videoView;

- (void)reloadData;
@end
