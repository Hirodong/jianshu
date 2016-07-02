//
//  HRDetailReadCell.h
//  jianshu
//
//  Created by Hiro on 16/5/23.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRDetailReadModel.h"
@interface HRDetailReadCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *web_urlImageView;
@property (weak, nonatomic) IBOutlet UILabel *hp_authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *hp_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hp_contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *auth_itLabel;
/**<#注释#>*/
@property (nonatomic,strong) HRDetailReadModel *detailModel;
@end
