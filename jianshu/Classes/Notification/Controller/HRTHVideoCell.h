//
//  HRTHVideoCell.h
//  jianshu
//
//  Created by Hiro on 16/5/19.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface HRTHVideoCell : UITableViewCell
@property (strong, nonatomic)VideoModel *model;

@property (strong, nonatomic)UIImageView *imgView;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UIButton *playBtn;

@property (strong, nonatomic)UIView *backView;
@end
