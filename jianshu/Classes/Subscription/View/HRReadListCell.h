//
//  HRReadListCell.h
//  jianshu
//
//  Created by Hiro on 16/5/21.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRReadListModel.h"
@interface HRReadListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *user_nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *hp_titleLabel;


@property (weak, nonatomic) IBOutlet UILabel *guide_wordLabel;



/**存放cell对应的模型*/
@property (nonatomic,strong) HRReadListModel *readListModel;
@end
