//
//  HRChannelCell.h
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRNewsTVC;
@interface HRChannelCell : UICollectionViewCell
/**新闻controller*/
@property (nonatomic,strong)  HRNewsTVC *newsTVC;
@property (nonatomic,copy)  NSString *urlString;
@end
