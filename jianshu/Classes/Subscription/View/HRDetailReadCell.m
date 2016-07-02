//
//  HRDetailReadCell.m
//  jianshu
//
//  Created by Hiro on 16/5/23.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRDetailReadCell.h"
#import "HRDetailReadModel.h"
#import "UIImageView+WebCache.h"
#import "HRReadListModel.h"
@implementation HRDetailReadCell



-(void)setDetailModel :(HRDetailReadModel *)detailModel {
    _detailModel =detailModel;
    [self.web_urlImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.web_url]];
    self.web_urlImageView.clipsToBounds = YES;
    self.web_urlImageView.layer.cornerRadius = 10;
    self.hp_authorLabel.text =detailModel.hp_author;
    self.hp_titleLabel.text = detailModel.hp_title;
    self.auth_itLabel.text= detailModel.auth_it;
     NSArray* contentsArray = [detailModel.hp_content componentsSeparatedByString:@"<br>"];
        NSMutableString *str =[[NSMutableString alloc]init];
        for (int i =0; i<contentsArray.count; i++) {
            [str appendString:contentsArray[i]];

        }
    self.hp_contentLabel.text =str;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HRDetailReadCell" owner:nil options:nil].lastObject;
    }
    return self;
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
