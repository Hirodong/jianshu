//
//  HRNewsCell.h
//  jianshu
//
//  Created by Hiro on 16/5/20.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRNewsModel;
@interface HRNewsCell : UITableViewCell
@property(nonatomic,strong)HRNewsModel *newsModel;
/**轮播点击事件*/
@property(nonatomic,copy)void(^cycleImageClickBlock)(NSInteger idx);




@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+(NSString*)cellReuseID:(HRNewsModel *)newsModel;
+(CGFloat)cellForHeight:(HRNewsModel *)newsModel;

@end
